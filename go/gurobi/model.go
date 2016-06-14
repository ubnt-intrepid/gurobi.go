package gurobi

// #include <gurobi_c.h>
import "C"
import "errors"

type Model struct {
	model *C.GRBmodel
	env   *Env
}

// create a new model from the environment.
func (env *Env) NewModel(modelname string) (*Model, error) {
	if env == nil {
		return nil, errors.New("This environment is not created yet.")
	}

	var model *C.GRBmodel = nil
	errcode := C.GRBnewmodel(env.env, &model, C.CString(modelname), 0, nil, nil, nil, nil, nil)
	if errcode != 0 {
		return nil, env.makeError(errcode)
	}

	return &Model{model: model, env: env}, nil
}

// free the model
func (model *Model) Free() {
	if model != nil {
		C.GRBfreemodel(model.model)
	}
}

func (model *Model) AddVars(numvars int32) error {
	if model == nil {
		return errors.New("")
	}

	err := C.GRBaddvars(model.model, (C.int)(numvars), 0, nil, nil, nil, nil, nil, nil, nil, nil)
	if err != 0 {
		return model.env.makeError(err)
	}

	return nil
}

func (model *Model) AddQPTerms(qrow []int32, qcol []int32, qval []float64) error {
	if model == nil {
		return errors.New("")
	}

	numterms := len(qrow)
	if numterms > len(qcol) {
		numterms = len(qcol)
	}
	if numterms > len(qval) {
		numterms = len(qval)
	}

	err := C.GRBaddqpterms(model.model, (C.int)(numterms), (*C.int)(&qrow[0]), (*C.int)(&qcol[0]), (*C.double)(&qval[0]))
	if err != 0 {
		return model.env.makeError(err)
	}

	return nil
}

func (model *Model) AddConstr(ind []int32, val []float64, sense int8, rhs float64, constrname string) error {
	if model == nil {
		return errors.New("")
	}

	numterms := len(ind)
	err := C.GRBaddconstr(model.model, (C.int)(numterms), (*C.int)(&ind[0]), (*C.double)(&val[0]), (C.char)(sense), (C.double)(rhs), C.CString(constrname))
	if err != 0 {
		return model.env.makeError(err)
	}

	return nil
}

// get an attribute from model
func (model *Model) GetIntAttr(attrname string) (int32, error) {
	if model == nil {
		return 0, errors.New("")
	}

	var attr int32
	err := C.GRBgetintattr(model.model, C.CString(attrname), (*C.int)(&attr))
	if err != 0 {
		return 0, model.env.makeError(err)
	}

	return attr, nil
}

// get an attribute from model
func (model *Model) GetDoubleAttr(attrname string) (float64, error) {
	if model == nil {
		return 0, errors.New("")
	}

	var attr float64
	err := C.GRBgetdblattr(model.model, C.CString(attrname), (*C.double)(&attr))
	if err != 0 {
		return 0, model.env.makeError(err)
	}

	return attr, nil
}

func (model *Model) GetDoubleAttrArray(attrname string, numvars int) ([]float64, error) {
	value := make([]float64, numvars)
	err := C.GRBgetdblattrarray(model.model, C.CString(attrname), 0, (C.int)(numvars), (*C.double)(&value[0]))
	return value, model.env.makeError(err)
}

func (model *Model) SetDoubleAttrElement(attr string, ind int32, value float64) error {
	err := C.GRBsetdblattrelement(model.model, C.CString(attr), (C.int)(ind), (C.double)(value))
	return model.env.makeError(err)
}

func (model *Model) Update() error {
	err := C.GRBupdatemodel(model.model)
	return model.env.makeError(err)
}

func (model *Model) Optimize() error {
	err := C.GRBoptimize(model.model)
	return model.env.makeError(err)
}

func (model *Model) Write(filename string) error {
	err := C.GRBwrite(model.model, C.CString(filename))
	return model.env.makeError(err)
}
