package main

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi65
import "C"
import "fmt"

func main() {
  var env   *C.GRBenv   = nil;
  var model *C.GRBmodel = nil;
  // var sol [3]float64;
  var ind [3]int32;
  var val [3]float64;
  var qcol [5]int32;
  var qrow [5]int32;
  var qval [5]float64;

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

  // Quadratic objective terms
  qrow[0] = 0; qrow[1] = 0; qrow[2] = 1; qrow[3] = 1; qrow[4] = 2;
  qcol[0] = 0; qcol[1] = 1; qcol[2] = 1; qcol[3] = 2; qcol[4] = 2;
  qval[0] = 1; qval[1] = 1; qval[2] = 1; qval[3] = 1; qval[4] = 1;

  err = C.GRBaddqpterms(model, 5, (*C.int)(&qrow[0]), (*C.int)(&qcol[0]), (*C.double)(&qval[0]));
  if err != 0 {
    goto QUIT;
  }

  // Linear objective term
  err = C.GRBsetdblattrelement(model, C.CString(C.GRB_DBL_ATTR_OBJ), 0, 2.0);
  if err != 0 {
    goto QUIT;
  }

  // First constraint
  ind[0] = 0; ind[1] = 1; ind[2] = 2;
  val[0] = 1; val[1] = 2; val[2] = 3;

  err = C.GRBaddconstr(model, 3, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 4.0, C.CString("c0"));
  if err != 0 {
    goto QUIT;
  }

  // Second constraint
  ind[0] = 0; ind[1] = 1;
  val[0] = 1; val[1] = 1;

  err = C.GRBaddconstr(model, 2, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 1.0, C.CString("c1"));
  if err != 0 {
    goto QUIT;
  }

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
