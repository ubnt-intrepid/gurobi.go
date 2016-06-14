package gurobi

// #include <gurobi_c.h>
import "C"

type Model struct {
	model *C.GRBmodel
}

func (model *Model) Free() {
	C.GRBfreemodel(model.model)
	model.model = nil
}

func (model *Model) AddVars(numvars int32) int {
	err := C.GRBaddvars(model.model, (C.int)(numvars), 0, nil, nil, nil, nil, nil, nil, nil, nil)
	return int(err)
}

func (model *Model) AddQPTerms(qrow []int32, qcol []int32, qval []float64) int {
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

func (model *Model) AddConstr(ind []int32, val []float64, sense int8, rhs float64, constrname string) int {
	numterms := len(ind)
	err := C.GRBaddconstr(model.model, (C.int)(numterms), (*C.int)(&ind[0]), (*C.double)(&val[0]), (C.char)(sense), (C.double)(rhs), C.CString(constrname))
	return int(err)
}

func (model *Model) SetDoubleAttrElement(attr string, ind int32, value float64) int {
	err := C.GRBsetdblattrelement(model.model, C.CString(attr), (C.int)(ind), (C.double)(value))
	return int(err)
}

func (model *Model) GetIntAttr(attrname string) (int32, int) {
	var attr int32
	err := C.GRBgetintattr(model.model, C.CString(attrname), (*C.int)(&attr))
	return attr, int(err)
}

func (model *Model) GetDoubleAttr(attrname string) (float64, int) {
	var attr float64
	err := C.GRBgetdblattr(model.model, C.CString(attrname), (*C.double)(&attr))
	return attr, int(err)
}

func (model *Model) Update() int {
	err := C.GRBupdatemodel(model.model)
	return int(err)
}

func (model *Model) Optimize() int {
	err := C.GRBoptimize(model.model)
	return int(err)
}

func (model *Model) Write(filename string) int {
	err := C.GRBwrite(model.model, C.CString(filename))
	return int(err)
}

func (model *Model) GetDoubleAttrArray(attrname string, numvars int) ([]float64, int) {
	value := make([]float64, numvars)
	err := C.GRBgetdblattrarray(model.model, C.CString(attrname), 0, (C.int)(numvars), (*C.double)(&value[0]))
	return value, int(err)
}