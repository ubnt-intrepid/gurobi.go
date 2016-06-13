package main

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi65
import "C"
import "fmt"

type Env struct {
	env *C.GRBenv
}

func newEnv(logfilename string) (env Env, err int) {
	err = int(C.GRBloadenv(&env.env, C.CString(logfilename)))
	return
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

func (model *Model) addQPTerms(qrow []int32, qcol []int32, qval []float64) int {
	numterms := len(qrow)
	if numterms > len(qcol) {
		numterms = len(qcol)
	}
	if numterms > len(qval) {
		numterms = len(qval)
	}

	err := C.GRBaddqpterms(model.model, (C.int)(numterms), (*C.int)(&qrow[0]), (*C.int)(&qcol[0]), (*C.double)(&qval[0]))
	return int(err)
}

func (model *Model) addConstr(ind []int32, val []float64, sense int8, rhs float64, constrname string) int {
	numterms := len(ind)
	err := C.GRBaddconstr(model.model, (C.int)(numterms), (*C.int)(&ind[0]), (*C.double)(&val[0]), (C.char)(sense), (C.double)(rhs), C.CString(constrname))
	return int(err)
}

func (model *Model) setDoubleAttrElement(attr string, ind int32, value float64) int {
	err := C.GRBsetdblattrelement(model.model, C.CString(attr), (C.int)(ind), (C.double)(value))
	return int(err)
}

func (model *Model) getIntAttr(attrname string) (int32, int) {
  var attr int32;
  err := C.GRBgetintattr(model.model, C.CString(attrname), (*C.int)(&attr))
  return attr, int(err)
}

func (model *Model) getDoubleAttr(attrname string) (float64, int) {
  var attr float64;
  err := C.GRBgetdblattr(model.model, C.CString(attrname), (*C.double)(&attr))
  return attr, int(err)
}

func (model *Model) update() int {
	err := C.GRBupdatemodel(model.model)
	return int(err)
}

func (model *Model) optimize() int {
	err := C.GRBoptimize(model.model)
	return int(err)
}

func (model *Model) write(filename string) int {
	err := C.GRBwrite(model.model, C.CString(filename))
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
	err = model.addQPTerms([]int32{0, 1, 1, 2, 2}, []int32{0, 0, 1, 1, 2}, []float64{1, 1, 1, 1, 1})
	if err != 0 {
		env.error()
		return
	}

	// Linear objective term
	err = model.setDoubleAttrElement(C.GRB_DBL_ATTR_OBJ, 0, 2.0)
	if err != 0 {
		env.error()
		return
	}

	// First constraint
	err = model.addConstr([]int32{0, 1, 2}, []float64{1, 2, 3}, C.GRB_GREATER_EQUAL, 4.0, "c0")
	if err != 0 {
		env.error()
		return
	}

	// Second constraint
	err = model.addConstr([]int32{0, 1, 2}, []float64{1, 1, 1}, C.GRB_GREATER_EQUAL, 1.0, "c1")
	if err != 0 {
		env.error()
		return
	}

	// Optimize model
	err = model.optimize()
	if err != 0 {
		env.error()
		return
	}

	// Write model to 'qp.lp'.
	err = model.write("qp.lp")
	if err != 0 {
		env.error()
		return
	}

	// Capture solution information
  optimstatus, err := model.getIntAttr(C.GRB_INT_ATTR_STATUS)
	if err != 0 {
		env.error()
		return
	}

	objval, err := model.getDoubleAttr(C.GRB_DBL_ATTR_OBJVAL)
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
