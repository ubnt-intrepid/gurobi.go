extern crate libc;
use self::libc::{c_char, c_int, c_double};

use std::ptr::null;
use std::ffi::{CStr, CString};

enum GRBenv {}
enum GRBmodel {}

#[link(name = "gurobi65", kind="static")]
// #[link(name = "gurobi56", kind="dylib")]
extern "C" {
  fn GRBgeterrormsg(env: *mut GRBenv) -> *mut c_char;
  fn GRBgetenv(model: *mut GRBmodel) -> *mut GRBenv;

  fn GRBloadenv(envP: *mut *mut GRBenv, logfilename: *const c_char) -> c_int;

  fn GRBfreeenv(env: *mut GRBenv) -> c_int;

  fn GRBnewmodel(env: *mut GRBenv,
                 modelP: *mut *mut GRBmodel,
                 Pname: *const c_char,
                 numvars: c_int,
                 obj: *const c_double,
                 lb: *const c_double,
                 ub: *const c_double,
                 vtype: *const c_char,
                 varnames: *const *const c_char)
                 -> c_int;

  fn GRBfreemodel(model: *mut GRBmodel) -> c_int;

  fn GRBupdatemodel(model: *mut GRBmodel) -> c_int;

  fn GRBoptimize(model: *mut GRBmodel) -> c_int;

  fn GRBaddvar(model: *mut GRBmodel,
               numnz: c_int,
               vind: *const c_int,
               vval: *const c_double,
               obj: c_double,
               lb: c_double,
               ub: c_double,
               vtype: c_char,
               varname: *const c_char)
               -> c_int;

  fn GRBaddconstr(model: *mut GRBmodel,
                  numnz: c_int,
                  cind: *const c_int,
                  cval: *const c_double,
                  sense: c_char,
                  rhs: c_double,
                  constrname: *const c_char)
                  -> c_int;

  fn GRBsetintattr(model: *mut GRBmodel,
                   attrname: *const c_char,
                   newvalue: c_int)
                   -> c_int;

  fn GRBgetintattr(model: *mut GRBmodel,
                   attrname: *const c_char,
                   value: *mut c_int)
                   -> c_int;
  fn GRBgetdblattr(model: *mut GRBmodel,
                   attrname: *const c_char,
                   value: *mut c_double)
                   -> c_int;

  fn GRBgetdblattrelement(model: *mut GRBmodel,
                          attrname: *const c_char,
                          element: c_int,
                          newvalue: *mut c_double)
                          -> c_int;

  fn GRBgetstrattrelement(model: *mut GRBmodel,
                          attrname: *const c_char,
                          element: c_int,
                          newvalue: *mut *mut c_char)
                          -> c_int;

  fn GRBgetstrattr(model: *mut GRBmodel,
                   attrname: *const c_char,
                   value: *mut *mut c_char)
                   -> c_int;

  fn GRBsetdblattrarray(model: *mut GRBmodel,
                        attrname: *const c_char,
                        first: c_int,
                        len: c_int,
                        newvalues: *const c_double)
                        -> c_int;
}

macro_rules! gurobi_call(
  ($func:ident, $($arg:expr),*) => (
    {
      println!("[calling {}]", stringify!($func));
      let ret = unsafe { $func( $($arg),* ) };
      match ret {
        0 => Ok(0),
        _ => Err(format!("An error was occurred. Error code is: {}", ret)),
      }
    }
  )
);

fn as_c_char(s: &str) -> *const c_char {
  CString::new(s).unwrap().as_ptr()
}

pub struct Env {
  env: *mut GRBenv,
}

impl Env {
  pub fn new(logfilename: &str) -> Result<Env, String> {
    let mut env = 0 as *mut GRBenv;
    match gurobi_call!(GRBloadenv, &mut env, as_c_char(logfilename)) {
      Ok(_) => Ok(Env { env: env }),
      Err(err) => Err(err),
    }
  }

  pub fn newModel(&mut self, modelname: &str) -> Result<Model, String> {
    let mut model = 0 as *mut GRBmodel;
    match gurobi_call!(GRBnewmodel,
                 self.env,
                  &mut model,
                  as_c_char(modelname),
                  0,
                  null(),
                  null(),
                  null(),
                  null(),
                  null()) {
      Ok(_) => {
        Ok(Model {
          model: model,
          varcnt: 0,
        })
      }
      Err(err) => Err(err),
    }
  }

  // destructor
  fn dispose(&mut self) {
    gurobi_call!(GRBfreeenv, &mut *self.env);
  }
}

impl Drop for Env {
  fn drop(&mut self) {
    self.dispose();
  }
}


pub struct Model {
  model: *mut GRBmodel,
  varcnt: u64,
}

impl Model {
  pub fn add_var(&mut self,
                 varname: &str,
                 vtype: char,
                 lb: f64,
                 ub: f64,
                 obj: f64)
                 -> Result<&mut Self, String> {
    match gurobi_call!(GRBaddvar,
                self.model,
                0,
                null(),
                null(),
                obj,
                lb,
                ub,
                vtype as c_char,
                as_c_char(varname)) {
      Ok(_) => {
        self.varcnt += 1;
        Ok(self)
      }
      Err(err) => Err(err),
    }
  }

  pub fn add_bvar(&mut self,
                  varname: &str,
                  obj: f64)
                  -> Result<&mut Self, String> {
    self.add_var(varname, 'B', 0.0, 1.0, obj)
  }

  pub fn add_constr(&mut self,
                    ind: Vec<i64>,
                    val: Vec<f64>,
                    sense: char,
                    rhs: f64,
                    constname: &str)
                    -> Result<&mut Self, String> {
    if ind.len() != val.len() {
      return Err("Index length wrong.".to_string());
    }
    let numnz = ind.len() as c_int;
    let cind = ind.iter().map(|&i| i as c_int).collect::<Vec<c_int>>();
    let cval = val.iter().map(|&i| i as c_double).collect::<Vec<c_double>>();
    match gurobi_call!(GRBaddconstr,
                self.model,
                   numnz,
                   &cind[0] as *const c_int,
                   &cval[0] as *const c_double,
                   sense as c_char,
                   rhs,
                   as_c_char(constname)) {
      Ok(_) => Ok(self),
      Err(err) => Err(err),
    }
  }

  pub fn get_int_attr(&self, attrname: &str) -> i64 {
    let mut value = 0 as c_int;
    gurobi_call!(GRBgetintattr, self.model, as_c_char(attrname), &mut value);
    value as i64
  }

  pub fn get_double_attr(&self, attrname: &str) -> f64 {
    let mut value = 0 as c_double;
    gurobi_call!(GRBgetdblattr, self.model, as_c_char(attrname), &mut value);
    value as f64
  }

  pub fn get_string_attr(&self, attrname: &str) -> &str {
    let mut value = 0 as *mut c_char;
    gurobi_call!(GRBgetstrattr, self.model, as_c_char(attrname), &mut value);
    unsafe { CStr::from_ptr(value).to_str().unwrap() }
  }

  pub fn set_int_attr(&mut self, attrname: &str, newvalue: i64) {
    let newvalue_ = newvalue as c_int;
    gurobi_call!(GRBsetintattr, self.model, as_c_char(attrname), newvalue_);
  }

  pub fn set_double_attr_array(&mut self,
                               attrname: &str,
                               first: i64,
                               newvalues: &Vec<f64>) {
    let newval = newvalues.iter()
      .map(|&i| i as c_double)
      .collect::<Vec<c_double>>();
    gurobi_call!(GRBsetdblattrarray, self.model,
                         as_c_char(attrname),
                         first as c_int,
                         newval.len() as c_int,
                         &newval[0] as *const c_double);
  }

  pub fn get_double_attr_element(&self, attrname: &str, element: i64) -> f64 {
    let mut value = 0 as c_double;
    gurobi_call!(GRBgetdblattrelement, self.model,
                           as_c_char(attrname),
                           element as c_int,
                           &mut value);
    value as f64
  }

  pub fn get_string_attr_element(&self, attrname: &str, element: i64) -> &str {
    let mut value = 0 as *mut c_char;
    gurobi_call!(GRBgetstrattrelement,self.model,
                           as_c_char(attrname),
                           element as c_int,
                           &mut value);
    unsafe { CStr::from_ptr(value).to_str().unwrap() }
  }

  pub fn set_objective(&mut self, coeffs: Vec<f64>, sense: i64) {
    self.set_double_attr_array("Obj", 0, &coeffs);
    self.set_int_attr("ModelSense", sense);
  }

  pub fn update(&mut self) {
    gurobi_call!(GRBupdatemodel, self.model);
  }

  pub fn optimize(&mut self) {
    gurobi_call!(GRBoptimize, self.model);
  }

  pub fn show_info(&self) {
    println!("---");

    let modelname = self.get_string_attr("ModelName");
    println!("modelname: {}", modelname);

    let status = self.get_int_attr("Status");
    println!("status: {}", status);

    let numvars = self.get_int_attr("NumVars");
    println!("vars:");
    for i in 0..numvars {
      let name = self.get_string_attr_element("VarName", i);
      println!("  - vname: {}", name);

      let val = self.get_double_attr_element("X", i);
      println!("    value: {}", val);
    }

    let objval = self.get_double_attr("ObjVal");
    println!("objval: {}", objval);

    println!("...");
  }

  fn dispose(&mut self) {
    if !self.model.is_null() {
      gurobi_call!(GRBfreemodel, &mut *self.model);
    }
    self.model = 0 as *mut GRBmodel;
  }
}

impl Drop for Model {
  fn drop(&mut self) {
    self.dispose();
  }
}
