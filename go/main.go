package main

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi65
import "C"
import "fmt"

func main() {
  var env *C.GRBenv = nil;
  var model *C.GRBmodel = nil;

  // Create environment.
  err := C.GRBloadenv(&env, C.CString("qp.log"));
  if err != 0 {
    goto QUIT;
  }

  // Create an empty model.
  err = C.GRBnewmodel(env, &model, C.CString("qp"), 0, nil, nil, nil, nil, nil);
  if err != 0 {
    goto QUIT;
  }

  // Add varibles
  err = C.GRBaddvars(model, 3, 0, nil, nil, nil, nil, nil, nil, nil, nil);
  if err != 0 {
    goto QUIT;
  }

  // Integrate new variables.
  err = C.GRBupdatemodel(model);
  if err != 0 {
    goto QUIT;
  }

  //

  // Optimize model
  err = C.GRBoptimize(model);
  if err != 0 {
    goto QUIT;
  }

  // Write model to 'qp.lp'.
  err = C.GRBwrite(model, C.CString("qp.lp"));
  if err != 0 {
    goto QUIT;
  }

QUIT:
  if err != 0 {
    fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env));
    return
  }

  C.GRBfreemodel(model);
  C.GRBfreeenv(env);
}
