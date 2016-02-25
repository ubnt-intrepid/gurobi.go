extern crate libc;

use std::str::FromStr;

struct _GRBenv;
struct _GRBmodel;

type GRBenv   = _GRBenv;
type GRBmodel = _GRBmodel;

#[link(name = "gurobi", kind="dylib")]
extern {
  fn GRBloadenv(envP: *mut*mut GRBenv, logfilename: libc::c_int)
      -> libc::c_int;
}

fn main() {
    let mut env = 0 as *mut GRBenv;
    unsafe { GRBloadenv(&mut env, FromStr::from_str("rust.log").unwrap()); }
    println!("Hello, rustc");
}
