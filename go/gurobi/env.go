package gurobi

// #include <gurobi_c.h>
import "C"
import "fmt"

type Env struct {
	env *C.GRBenv
}

func NewEnv(logfilename string) (env Env, err int) {
	err = int(C.GRBloadenv(&env.env, C.CString(logfilename)))
	return
}

func (env *Env) Free() {
	C.GRBfreeenv(env.env)
	env.env = nil
}

func (env *Env) Error() {
	fmt.Printf("ERROR: %s\n", C.GRBgeterrormsg(env.env))
}

func (env *Env) NewModel(modelname string) (Model, int) {
	var model *C.GRBmodel = nil
	err := C.GRBnewmodel(env.env, &model, C.CString(modelname), 0, nil, nil, nil, nil, nil)
	return Model{model: model}, int(err)
}
