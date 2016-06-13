package main

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi65
import "C"
import "fmt"

type Env struct {
	env *C.GRBenv
}

func newEnv(logfilename string) (Env, int) {
	var env *C.GRBenv = nil
	err := C.GRBloadenv(&env, C.CString(logfilename))
	return Env{env: env}, int(err)
}

func (env *Env) free() {
	C.GRBfreeenv(env.env)
	env.env = nil
}

func (env *Env) error() {
	fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env.env))
}

type Model struct {
	model *C.GRBmodel
}

func (env *Env) newModel(modelname string) (Model, int) {
	var model *C.GRBmodel = nil
	err := C.GRBnewmodel(env.env, &model, C.CString(modelname), 0, nil, nil, nil, nil, nil)
	return Model{model: model}, int(err)
}

func (model *Model) free() {
	C.GRBfreemodel(model.model)
	model.model = nil
}

func (model *Model) addVars(numvars int32) int {
	err := C.GRBaddvars(model.model, (C.int)(numvars), 0, nil, nil, nil, nil, nil, nil, nil, nil)
	return int(err)
}

func (model *Model) update() int {
	err := C.GRBupdatemodel(model.model)
	return int(err)
}

func main() {
	// Create environment.
	env, err := newEnv("qp.log")
	if err != 0 {
		return
	}
	defer env.free()

	// Create an empty model.
	model, err := env.newModel("qp")
	if err != 0 {
		env.error()
		return
	}
	defer model.free()

	// Add varibles
	err = model.addVars(3)
	if err != 0 {
		env.error()
		return
	}

	// Integrate new variables.
	err = model.update()
	if err != 0 {
		env.error()
		return
	}

	// Quadratic objective terms
	qcol := [5]int32{0, 0, 1, 1, 2}
	qrow := [5]int32{0, 1, 1, 2, 2}
	qval := [5]float64{1, 1, 1, 1, 1}

	err = C.GRBaddqpterms(model, 5, (*C.int)(&qrow[0]), (*C.int)(&qcol[0]), (*C.double)(&qval[0]))
	if err != 0 {
		env.error()
		return
	}

	// Linear objective term
	err = C.GRBsetdblattrelement(model, C.CString(C.GRB_DBL_ATTR_OBJ), 0, 2.0)
	if err != 0 {
		env.error()
		return
	}

	// First constraint
	ind := [3]int32{0, 1, 2}
	val := [3]float64{1, 2, 3}

	err = C.GRBaddconstr(model, 3, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 4.0, C.CString("c0"))
	if err != 0 {
		env.error()
		return
	}

	// Second constraint
	ind = [3]int32{0, 1, 2}
	val = [3]float64{1, 1, 1}

	err = C.GRBaddconstr(model, 2, (*C.int)(&ind[0]), (*C.double)(&val[0]), C.GRB_GREATER_EQUAL, 1.0, C.CString("c1"))
	if err != 0 {
		env.error()
		return
	}

	// Optimize model
	err = C.GRBoptimize(model)
	if err != 0 {
		env.error()
		return
	}

	// Write model to 'qp.lp'.
	err = C.GRBwrite(model, C.CString("qp.lp"))
	if err != 0 {
		env.error()
		return
	}

	// Capture solution information
	var optimstatus int32
	err = C.GRBgetintattr(model, C.CString(C.GRB_INT_ATTR_STATUS), (*C.int)(&optimstatus))
	if err != 0 {
		env.error()
		return
	}

	var objval float64
	err = C.GRBgetdblattr(model, C.CString(C.GRB_DBL_ATTR_OBJVAL), (*C.double)(&objval))
	if err != 0 {
		env.error()
		return
	}

	var sol [3]float64
	err = C.GRBgetdblattrarray(model, C.CString(C.GRB_DBL_ATTR_X), 0, 3, (*C.double)(&sol[0]))
	if err != 0 {
		env.error()
		return
	}

	fmt.Printf("\nOptimization complete\n")
	if optimstatus == C.GRB_OPTIMAL {
		fmt.Printf("Optimal objective: %.4e\n", objval)
	} else if optimstatus == C.GRB_INF_OR_UNBD {
		fmt.Printf("Model is infeasible or unbounded\n")
	} else {
		fmt.Printf("Optimization was stopped early\n")
	}
}
