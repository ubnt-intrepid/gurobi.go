extern crate libc;

use std::ptr::null;
use libc::{c_char, c_int, c_double};
use std::ffi::CStr;

enum GRBenv {}
enum GRBmodel {}

#[link(name = "gurobi65", kind="static")]
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


fn as_c_char(s: &str) -> *const c_char {
  s.to_string().as_ptr() as *const c_char
}

pub struct Env {
  env: *mut GRBenv,
}

impl Env {
  pub fn new(logfilename: &str) -> Env {
    let mut env = 0 as *mut GRBenv;

    println!("[call GRBloadenv]");
    let ret = unsafe { GRBloadenv(&mut env, as_c_char(logfilename)) };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }

    Env { env: env }
  }

  pub fn dispose(&mut self) {
    println!("[call GRBfreeenv]");
    unsafe { GRBfreeenv(&mut *self.env) };
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
  pub fn new(env: &Env, modelname: &str) -> Model {
    let mut model = 0 as *mut GRBmodel;

    println!("[call GRBnewmodel]");
    let ret = unsafe {
      GRBnewmodel(env.env,
                  &mut model,
                  as_c_char(modelname),
                  0,
                  null(),
                  null(),
                  null(),
                  null(),
                  null())
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }

    Model {
      model: model,
      varcnt: 0,
    }
  }

  pub fn add_var(&mut self,
                 lb: f64,
                 ub: f64,
                 obj: f64,
                 vtype: char,
                 varname: &str) {
    println!("[call GRBaddvar]");
    let ret = unsafe {
      GRBaddvar(self.model,
                0,
                null(),
                null(),
                obj,
                lb,
                ub,
                vtype as c_char,
                as_c_char(varname))
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }

    self.varcnt += 1;
  }

  pub fn add_constr(&mut self,
                    ind: Vec<i64>,
                    val: Vec<f64>,
                    sense: char,
                    rhs: f64,
                    constname: &str) {
    assert!(ind.len() == val.len());
    let numnz = ind.len() as c_int;
    let cind = ind.iter().map(|&i| i as c_int).collect::<Vec<c_int>>();
    let cval = val.iter().map(|&i| i as c_double).collect::<Vec<c_double>>();
    let ret = unsafe {
      GRBaddconstr(self.model,
                   numnz,
                   &cind[0] as *const c_int,
                   &cval[0] as *const c_double,
                   sense as c_char,
                   rhs,
                   as_c_char(constname))
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
  }

  pub fn get_int_attr(&self, attrname: &str) -> i64 {
    let mut value = 0 as c_int;
    let ret = unsafe {
      GRBgetintattr(self.model, as_c_char(attrname), &mut value)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
    value as i64
  }

  pub fn get_double_attr(&self, attrname: &str) -> f64 {
    let mut value = 0 as c_double;
    let ret = unsafe {
      GRBgetdblattr(self.model, as_c_char(attrname), &mut value)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
    value as f64
  }

  pub fn get_string_attr(&self, attrname: &str) -> &str {
    let mut value = 0 as *mut c_char;
    let ret = unsafe {
      GRBgetstrattr(self.model, as_c_char(attrname), &mut value)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
    unsafe { CStr::from_ptr(value).to_str().unwrap() }
  }

  pub fn set_int_attr(&mut self, attrname: &str, newvalue: i64) {
    let ret = unsafe {
      GRBsetintattr(self.model, as_c_char(attrname), newvalue as c_int)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
  }

  pub fn set_double_attr_array(&mut self,
                               attrname: &str,
                               first: i64,
                               newvalues: &Vec<f64>) {
    let newval = newvalues.iter()
                          .map(|&i| i as c_double)
                          .collect::<Vec<c_double>>();
    let ret = unsafe {
      GRBsetdblattrarray(self.model,
                         as_c_char(attrname),
                         first as c_int,
                         newval.len() as c_int,
                         &newval[0] as *const c_double)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
  }

  pub fn get_double_attr_element(&self, attrname: &str, element: i64) -> f64 {
    let mut value = 0 as c_double;
    let ret = unsafe {
      GRBgetdblattrelement(self.model,
                           as_c_char(attrname),
                           element as c_int,
                           &mut value)
    };
    if ret != 0 {
      let msg = unsafe {
        let env = GRBgetenv(self.model);
        assert!(env != 0 as *mut GRBenv);
        CStr::from_ptr(GRBgeterrormsg(env)).to_str().unwrap()
      };
      panic!("An error was occurred. Error code is: {0}, message: {1}",
             ret,
             msg);
    }
    value as f64
  }

  pub fn get_string_attr_element(&self, attrname: &str, element: i64) -> &str {
    let mut value = 0 as *mut c_char;
    let ret = unsafe {
      GRBgetstrattrelement(self.model,
                           as_c_char(attrname),
                           element as c_int,
                           &mut value)
    };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
    unsafe { CStr::from_ptr(value).to_str().unwrap() }
  }

  pub fn set_objective(&mut self, coeffs: Vec<f64>, sense: i64) {
    self.set_double_attr_array("Obj", 0, &coeffs);
    self.set_int_attr("ModelSense", sense);
  }

  pub fn update(&mut self) {
    println!("[call GRBupdatemodel]");
    let ret = unsafe { GRBupdatemodel(self.model) };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
  }

  pub fn optimize(&mut self) {
    println!("[call GRBoptimize]");
    let ret = unsafe { GRBoptimize(self.model) };
    if ret != 0 {
      panic!("An error was occurred. Error code is: {}", ret);
    }
  }

  pub fn dispose(&mut self) {
    if !self.model.is_null() {
      println!("[call GRBfreemodel]");
      unsafe { GRBfreemodel(&mut *self.model) };
    }
    self.model = 0 as *mut GRBmodel;
  }
}

impl Drop for Model {
  fn drop(&mut self) {
    self.dispose();
  }
}


fn main() {
  let env = Env::new("model.log");
  let mut model = Model::new(&env, "mip1");

  model.add_var(0.0, 1.0, 0.0, 'B', "x");
  model.add_var(0.0, 1.0, 0.0, 'B', "y");
  model.add_var(0.0, 1.0, 0.0, 'B', "z");
  model.update();

  model.add_constr(vec![0, 1, 2], vec![1., 2., 3.], '<', 4.0, "c0");
  model.add_constr(vec![0, 1], vec![1., 2.], '>', 1.0, "c1");

  model.set_objective(vec![1., 1., 2.], -1);

  model.optimize();

  let numvars = model.get_int_attr("NumVars");
  assert!(numvars == 3);

  // let xname = model.get_string_attr_element("VarName", 0);
  // println!("x = {}", xname);

  let obj = model.get_double_attr("ObjVal");
  println!("Obj: {}", obj);
}
