package gurobi

// #include <gurobi_c.h>
import "C"
import "errors"

// Gurobi model object
type Model struct {
	model   *C.GRBmodel
	env     Env
	vars    []Var
	constrs []Constr
}

// create a new model from the environment.
func NewModel(modelname string, env *Env) (*Model, error) {
	if env == nil {
		return nil, errors.New("This environment is not created yet.")
	}

	var model *C.GRBmodel = nil
	errcode := C.GRBnewmodel(env.env, &model, C.CString(modelname), 0, nil, nil, nil, nil, nil)
	if errcode != 0 {
		return nil, env.makeError(errcode)
	}

	newenv := C.GRBgetenv(model)
	if newenv == nil {
		return nil, errors.New("Failed retrieve the environment")
	}

	return &Model{model: model, env: Env{newenv}}, nil
}

// free the model
func (model *Model) Free() {
	if model == nil {
		return
	}
	C.GRBfreemodel(model.model)
}

// create a variable to the model
func (model *Model) AddVar(vtype int8, obj float64, lb float64, ub float64, name string, constrs []*Constr, columns []float64) (*Var, error) {
	if model == nil {
		return nil, errors.New("model is not initialized")
	}

	if len(constrs) != len(columns) {
		return nil, errors.New("either the length of constrs or columns are wrong")
	}

	ind := make([]int32, len(constrs), 0)
	for i, c := range constrs {
		if c.idx < 0 {
			return nil, errors.New("Invalid index in constrs")
		}
		ind[i] = c.idx
	}

	pind := (*C.int)(nil)
	pval := (*C.double)(nil)
	if len(ind) > 0 {
		pind = (*C.int)(&ind[0])
		pval = (*C.double)(&columns[0])
	}

	err := C.GRBaddvar(model.model, (C.int)(len(constrs)), pind, pval, (C.double)(obj), (C.double)(lb), (C.double)(ub), (C.char)(vtype), C.CString(name))
	if err != 0 {
		return nil, model.makeError(err)
	}

	if err := model.Update(); err != nil {
		return nil, err
	}

	model.vars = append(model.vars, Var{model, int32(len(model.vars))})
	return &model.vars[len(model.vars)-1], nil
}

func (model *Model) AddVars(vtype []int8, obj []float64, lb []float64, ub []float64, name []string, constrs [][]*Constr, columns [][]float64) ([]*Var, error) {
	if model == nil {
		return nil, errors.New("")
	}

	if len(vtype) != len(obj) || len(obj) != len(lb) || len(lb) != len(ub) || len(ub) != len(name) || len(name) != len(constrs) || len(constrs) != len(columns) {
		return nil, errors.New("")
	}

	vname := make([](*C.char), len(vtype), 0)
	for i, n := range name {
		vname[i] = C.CString(n)
	}

	numnz := 0
	for _, constr := range constrs {
		numnz += len(constr)
	}

	beg := make([]int32, len(constrs), 0)
	ind := make([]int32, numnz, 0)
	val := make([]float64, numnz, 0)
	k := 0
	for i := 0; i < len(constrs); i++ {
		if len(constrs[i]) != len(columns[i]) {
			return nil, errors.New("")
		}
		beg[i] = int32(k)

		for j := 0; j < len(constrs[i]); j++ {
			idx := constrs[i][j].idx
			if idx < 0 {
				return nil, errors.New("")
			}
			ind[k+j] = idx
			val[k+j] = columns[i][j]
		}

		k += len(constrs[i])
	}

	err := C.GRBaddvars(model.model, (C.int)(len(vtype)), (C.int)(numnz), (*C.int)(&beg[0]), (*C.int)(&ind[0]), (*C.double)(&val[0]), (*C.double)(&obj[0]), (*C.double)(&lb[0]), (*C.double)(&ub[0]), (*C.char)(&vtype[0]), (**C.char)(&vname[0]))
	if err != 0 {
		return nil, model.makeError(err)
	}

	if err := model.Update(); err != nil {
		return nil, err
	}

	vars := make([]*Var, len(vtype), 0)
	xcols := len(model.vars)
	for i := xcols; i < xcols+len(vtype); i++ {
		model.vars = append(model.vars, Var{model, int32(i)})
		vars[i] = &model.vars[len(model.vars)-1]
	}
	return vars, nil
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
		return model.makeError(err)
	}

	return nil
}

// add a constraint into the model.
func (model *Model) AddConstr(ind []int32, val []float64, sense int8, rhs float64, constrname string) error {
	if model == nil {
		return errors.New("")
	}

	numterms := len(ind)
	err := C.GRBaddconstr(model.model, (C.int)(numterms), (*C.int)(&ind[0]), (*C.double)(&val[0]), (C.char)(sense), (C.double)(rhs), C.CString(constrname))
	if err != 0 {
		return model.makeError(err)
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
		return 0, model.makeError(err)
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
		return 0, model.makeError(err)
	}

	return attr, nil
}

func (model *Model) GetDoubleAttrArray(attrname string, numvars int) ([]float64, error) {
	if model == nil {
		return []float64{}, errors.New("")
	}

	value := make([]float64, numvars)
	err := C.GRBgetdblattrarray(model.model, C.CString(attrname), 0, (C.int)(numvars), (*C.double)(&value[0]))
	if err != 0 {
		return []float64{}, model.makeError(err)
	}

	return value, nil
}

func (model *Model) SetDoubleAttrElement(attr string, ind int32, value float64) error {
	if model == nil {
		return errors.New("")
	}

	err := C.GRBsetdblattrelement(model.model, C.CString(attr), (C.int)(ind), (C.double)(value))
	if err != 0 {
		return model.makeError(err)
	}

	return nil
}

func (model *Model) Update() error {
	if model == nil {
		return errors.New("")
	}

	err := C.GRBupdatemodel(model.model)
	if err != 0 {
		return model.makeError(err)
	}

	return nil
}

func (model *Model) Optimize() error {
	if model == nil {
		return errors.New("")
	}

	err := C.GRBoptimize(model.model)
	if err != 0 {
		return model.makeError(err)
	}

	return nil
}

func (model *Model) Write(filename string) error {
	if model == nil {
		return errors.New("")
	}

	err := C.GRBwrite(model.model, C.CString(filename))
	if err != 0 {
		return model.makeError(err)
	}

	return nil
}
