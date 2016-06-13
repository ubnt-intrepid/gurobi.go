package main

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi65
import "C"
import "fmt"

func main() {
	// Create environment.
	var env *C.GRBenv = nil
	err := C.GRBloadenv(&env, C.CString("qp.log"))
	if err != 0 {
		return
	}
	defer C.GRBfreeenv(env)

	// Create an empty model.
	var model *C.GRBmodel = nil
	err = C.GRBnewmodel(env, &model, C.CString("qp"), 0, nil, nil, nil, nil, nil)
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}
	defer C.GRBfreemodel(model)

	// Add varibles
	err = C.GRBaddvars(model, 3, 0, nil, nil, nil, nil, nil, nil, nil, nil)
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Integrate new variables.
	err = C.GRBupdatemodel(model)
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Quadratic objective terms
	qcol := [5]int32{0, 0, 1, 1, 2}
	qrow := [5]int32{0, 1, 1, 2, 2}
	qval := [5]float64{1, 1, 1, 1, 1}

	err = C.GRBaddqpterms(model, 5, (*C.int)(&qrow[0]), (*C.int)(&qcol[0]), (*C.double)(&qval[0]))
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Linear objective term
	err = C.GRBsetdblattrelement(model, C.CString(C.GRB_DBL_ATTR_OBJ), 0, 2.0)
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// First constraint
	ind := [3]int32{0, 1, 2}
	val := [3]float64{1, 2, 3}

	err = C.GRBaddconstr(model, 3, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 4.0, C.CString("c0"))
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Second constraint
	ind = [3]int32{0, 1, 2}
	val = [3]float64{1, 1, 1}

	err = C.GRBaddconstr(model, 2, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 1.0, C.CString("c1"))
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Optimize model
	err = C.GRBoptimize(model)
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Write model to 'qp.lp'.
	err = C.GRBwrite(model, C.CString("qp.lp"))
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	// Capture solution information
	var optimstatus int32;
	err = C.GRBgetintattr(model, C.CString(C.GRB_INT_ATTR_STATUS), (*C.int)(&optimstatus));
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	var objval float64;
	err = C.GRBgetdblattr(model, C.CString(C.GRB_DBL_ATTR_OBJVAL), (*C.double)(&objval));
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	var sol [3] float64;
	err = C.GRBgetdblattrarray(model, C.CString(C.GRB_DBL_ATTR_X), 0, 3, (*C.double)(&sol[0]));
	if err != 0 {
		fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env))
		return
	}

	fmt.Printf("\nOptimization complete\n");
	if optimstatus == C.GRB_OPTIMAL {
		fmt.Printf("Optimal objective: %.4e\n", objval);
	} else if optimstatus == C.GRB_INF_OR_UNBD {
		fmt.Printf("Model is infeasible or unbounded\n");
	} else {
		fmt.Printf("Optimization was stopped early\n");
  }
}
