package gurobi

// #include <gurobi_passthrough.h>
import "C"
import "errors"

type Env struct {
	env *C.GRBenv
}

// create a new environment.
func NewEnv(logfilename string) (*Env, error) {
	var env *C.GRBenv = nil
	errcode := int(C.GRBloadenv(&env, C.CString(logfilename)))
	if errcode != 0 {
		return nil, errors.New("Cannot create environment.")
	}

	return &Env{env}, nil
}

// free environment.
func (env *Env) Free() {
	if env != nil {
		C.GRBfreeenv(env.env)
	}
}
