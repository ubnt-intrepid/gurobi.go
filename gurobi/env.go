package gurobi

// #include <gurobi_passthrough.h>
import "C"
import (
	"errors"
	"fmt"
)

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

/*
SetTimeLimit
Description:
	This member function is meant to set the time limit of the environment that has
	been created in Gurobi.
*/
func (env *Env) SetTimeLimit(limitIn float64) error {
	// Constants
	paramName := "TimeLimit"

	// Algorithm

	if env == nil {
		return fmt.Errorf("The input env variable to SetTimeLimit() was nil!")
	}

	errcode := int(C.GRBsetdblparam(env.env, C.CString(paramName), C.double(limitIn)))
	if errcode != 0 {
		return fmt.Errorf("There was an error running GRBsetdblparam(): Error code %v", errcode)
	}

	// If everything was successful, then return nil.
	return nil

}

/*
GetTimeLimit
Description:
	This member function is meant to set the time limit of the environment that has
	been created in Gurobi.
*/
func (env *Env) GetTimeLimit() (float64, error) {
	// Constants
	paramName := "TimeLimit"

	// Algorithm

	if env == nil {
		return -1, fmt.Errorf("The input env variable to SetTimeLimit() was nil!")
	}

	var limitOut C.double
	errcode := int(C.GRBgetdblparam(env.env, C.CString(paramName), &limitOut))
	if errcode != 0 {
		return -1, fmt.Errorf("There was an error running GRBsetdblparam(): Error code %v", errcode)
	}

	// If everything was successful, then return nil.
	return float64(limitOut), nil

}
