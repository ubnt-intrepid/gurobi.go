package gurobi

// #include <gurobi_c.h>
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
	if env.env != nil {
		C.GRBfreeenv(env.env)
		env.env = nil
	}
}

// make an error object from error code.
func (env *Env) makeError(errcode C.int) error {
	if errcode != 0 {
		return errors.New(C.GoString(C.GRBgeterrormsg(env.env)))
	} else {
		return nil
	}
}
