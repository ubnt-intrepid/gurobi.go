extern crate libc;

use libc::{c_char, c_int};

enum _GRBenv {}
type GRBenv   = _GRBenv;

enum _GRBmodel {}
type GRBmodel = _GRBmodel;

#[link(name = "gurobi65", kind="static")]
extern {
  fn GRBloadenv(envP: *mut*mut GRBenv, logfilename: *const c_char) -> c_int;
  fn GRBfreeenv(env: *mut GRBenv) -> c_int;
}


pub struct Env {
    env: *mut GRBenv
}

impl Env {

    pub fn new(logfilename: &str) -> Env
    {
        println!("Construct GRBenv");
        let mut env = 0 as *mut GRBenv;
        unsafe {
            GRBloadenv(&mut env, logfilename.to_string().as_ptr() as *const c_char)
        };
        Env { env: env }
    }

}

impl Drop for Env {
    fn drop(&mut self)
    {
        println!("Destruct GRBenv");
        unsafe { GRBfreeenv(&mut *self.env) };
    }
}

fn main() {
    // create a Gurobi environment.
    let mut env = Env::new("rust.log");
}
