package gurobi

// #include <gurobi_c.h>
import "C"
import "errors"

// Model ...
// Gurobi model object
type Model struct {
	model   *C.GRBmodel
	env     Env
	vars    []Var
	constrs []Constr
}

// NewModel ...
// create a new model from the environment.
func NewModel(modelname string, env *Env) (*Model, error) {
	if env == nil {
		return nil, errors.New("This environment is not created yet.")
	}

	var model *C.GRBmodel
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

// Free ...
// free the model
func (model *Model) Free() {
	if model == nil {
		return
	}
	C.GRBfreemodel(model.model)
}

// AddVar ...
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

	err := C.GRBaddvar(model.model, C.int(len(constrs)), pind, pval, C.double(obj), C.double(lb), C.double(ub), C.char(vtype), C.CString(name))
	if err != 0 {
		return nil, model.makeError(err)
	}

	if err := model.Update(); err != nil {
		return nil, err
	}

	model.vars = append(model.vars, Var{model, int32(len(model.vars))})
	return &model.vars[len(model.vars)-1], nil
}

// AddVars ...
func (model *Model) AddVars(vtype []int8, obj []float64, lb []float64, ub []float64, name []string, constrs [][]*Constr, columns [][]float64) ([]*Var, error) {
	if model == nil {
		return nil, errors.New("")
	}

	if len(vtype) != len(obj) || len(obj) != len(lb) || len(lb) != len(ub) || len(ub) != len(name) || len(name) != len(constrs) || len(constrs) != len(columns) {
		return nil, errors.New("")
	}

	numnz := 0
	for _, constr := range constrs {
		numnz += len(constr)
	}

	beg := make([]int32, len(constrs))
	ind := make([]int32, numnz)
	val := make([]float64, numnz)
	k := 0
	for i := 0; i < len(constrs); i++ {
		if len(constrs[i]) != len(columns[i]) {
			return nil, errors.New("")
		}

		for j := 0; j < len(constrs[i]); j++ {
			idx := constrs[i][j].idx
			if idx < 0 {
				return nil, errors.New("")
			}
			ind[k+j] = idx
			val[k+j] = columns[i][j]
		}

		beg[i] = int32(k)
		k += len(constrs[i])
	}

	vname := make([](*C.char), len(vtype))
	for i, n := range name {
		vname[i] = C.CString(n)
	}

	pbeg := (*C.int)(nil)
	pind := (*C.int)(nil)
	pval := (*C.double)(nil)
	if len(beg) > 0 {
		pbeg = (*C.int)(&beg[0])
		pind = (*C.int)(&ind[0])
		pval = (*C.double)(&val[0])
	}

	pobj := (*C.double)(nil)
	plb := (*C.double)(nil)
	pub := (*C.double)(nil)
	pvtype := (*C.char)(nil)
	pname := (**C.char)(nil)
	if len(vtype) > 0 {
		pobj = (*C.double)(&obj[0])
		plb = (*C.double)(&lb[0])
		pub = (*C.double)(&ub[0])
		pvtype = (*C.char)(&vtype[0])
		pname = (**C.char)(&vname[0])
	}

	err := C.GRBaddvars(model.model, C.int(len(vtype)), C.int(numnz), pbeg, pind, pval, pobj, plb, pub, pvtype, pname)
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

// AddConstr ...
// add a constraint into the model.
func (model *Model) AddConstr(vars []*Var, val []float64, sense int8, rhs float64, constrname string) (*Constr, error) {
	if model == nil {
		return nil, errors.New("")
	}

	ind := make([]int32, len(vars))
	for i, v := range vars {
		if v.idx < 0 {
			return nil, errors.New("Invalid vars")
		}
		ind[i] = v.idx
	}

	pind := (*C.int)(nil)
	pval := (*C.double)(nil)
	if len(ind) > 0 {
		pind = (*C.int)(&ind[0])
		pval = (*C.double)(&val[0])
	}

	err := C.GRBaddconstr(model.model, C.int(len(ind)), pind, pval, C.char(sense), C.double(rhs), C.CString(constrname))
	if err != 0 {
		return nil, model.makeError(err)
	}

	if err := model.Update(); err != nil {
		return nil, err
	}

	model.constrs = append(model.constrs, Constr{model, int32(len(model.constrs))})
	return &model.constrs[len(model.constrs)-1], nil
}

// AddQPTerms ...
func (model *Model) AddQPTerms(qrow []*Var, qcol []*Var, qval []float64) error {
	if model == nil {
		return errors.New("")
	}

	if len(qrow) != len(qcol) || len(qcol) != len(qval) {
		return errors.New("")
	}

	_qrow := make([]int32, len(qrow))
	_qcol := make([]int32, len(qcol))
	for i := 0; i < len(qrow); i++ {
		if qrow[i].idx < 0 {
			return errors.New("")
		}
		if qcol[i].idx < 0 {
			return errors.New("")
		}

		_qrow[i] = qrow[i].idx
		_qcol[i] = qcol[i].idx
	}

	pqrow := (*C.int)(nil)
	pqcol := (*C.int)(nil)
	pqval := (*C.double)(nil)
	if len(qrow) > 0 {
		pqrow = (*C.int)(&_qrow[0])
		pqcol = (*C.int)(&_qcol[0])
		pqval = (*C.double)(&qval[0])
	}

	err := C.GRBaddqpterms(model.model, C.int(len(qrow)), pqrow, pqcol, pqval)
	if err != 0 {
		return model.makeError(err)
	}

	return nil
}

// Update ...
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

// Optimize ...
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

// Write ...
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

// GetIntAttr ...
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

// GetDoubleAttr ...
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

// GetStringAttr ...
func (model *Model) GetStringAttr(attrname string) (string, error) {
	if model == nil {
		return "", errors.New("")
	}
	var attr *C.char
	err := C.GRBgetstrattr(model.model, C.CString(attrname), (**C.char)(&attr))
	if err != 0 {
		return "", model.makeError(err)
	}
	return C.GoString(attr), nil
}

// GetDoubleAttrVars ...
func (model *Model) GetDoubleAttrVars(attrname string, vars []*Var) ([]float64, error) {
	ind := make([]int32, len(vars))
	for i, v := range vars {
		if v.idx < 0 {
			return []float64{}, errors.New("")
		}
		ind[i] = v.idx
	}
	return model.getDoubleAttrList(attrname, ind)
}

// SetDoubleAttrVars ...
func (model *Model) SetDoubleAttrVars(attrname string, vars []*Var, value []float64) error {
	ind := make([]int32, len(vars))
	for i, v := range vars {
		if v.idx < 0 {
			return errors.New("")
		}
		ind[i] = v.idx
	}
	return model.setDoubleAttrList(attrname, ind, value)
}

func (model *Model) getIntAttrElement(attr string, ind int32) (int32, error) {
	if model == nil {
		return 0.0, errors.New("")
	}
	var value int32
	err := C.GRBgetintattrelement(model.model, C.CString(attr), C.int(ind), (*C.int)(&value))
	if err != 0 {
		return 0, model.makeError(err)
	}
	return value, nil
}

func (model *Model) getCharAttrElement(attr string, ind int32) (int8, error) {
	if model == nil {
		return 0, errors.New("")
	}
	var value int8
	err := C.GRBgetcharattrelement(model.model, C.CString(attr), C.int(ind), (*C.char)(&value))
	if err != 0 {
		return 0, model.makeError(err)
	}
	return value, nil
}

func (model *Model) getDoubleAttrElement(attr string, ind int32) (float64, error) {
	if model == nil {
		return 0, errors.New("")
	}
	var value float64
	err := C.GRBgetdblattrelement(model.model, C.CString(attr), C.int(ind), (*C.double)(&value))
	if err != 0 {
		return 0, model.makeError(err)
	}
	return value, nil
}

func (model *Model) getStringAttrElement(attr string, ind int32) (string, error) {
	if model == nil {
		return "", errors.New("")
	}
	var value *C.char
	err := C.GRBgetstrattrelement(model.model, C.CString(attr), C.int(ind), (**C.char)(&value))
	if err != 0 {
		return "", model.makeError(err)
	}
	return C.GoString(value), nil
}

func (model *Model) setIntAttrElement(attr string, ind int32, value int32) error {
	if model == nil {
		return errors.New("")
	}
	err := C.GRBsetintattrelement(model.model, C.CString(attr), C.int(ind), C.int(value))
	if err != 0 {
		return model.makeError(err)
	}
	return nil
}

func (model *Model) setCharAttrElement(attr string, ind int32, value int8) error {
	if model == nil {
		return errors.New("")
	}
	err := C.GRBsetcharattrelement(model.model, C.CString(attr), C.int(ind), C.char(value))
	if err != 0 {
		return model.makeError(err)
	}
	return nil
}

func (model *Model) setDoubleAttrElement(attr string, ind int32, value float64) error {
	if model == nil {
		return errors.New("")
	}
	err := C.GRBsetdblattrelement(model.model, C.CString(attr), C.int(ind), C.double(value))
	if err != 0 {
		return model.makeError(err)
	}
	return nil
}

func (model *Model) setStringAttrElement(attr string, ind int32, value string) error {
	if model == nil {
		return errors.New("")
	}
	err := C.GRBsetstrattrelement(model.model, C.CString(attr), C.int(ind), C.CString(value))
	if err != 0 {
		return model.makeError(err)
	}
	return nil
}

func (model *Model) getDoubleAttrList(attrname string, ind []int32) ([]float64, error) {
	if model == nil {
		return []float64{}, errors.New("")
	}
	if len(ind) == 0 {
		return []float64{}, nil
	}
	value := make([]float64, len(ind))
	err := C.GRBgetdblattrlist(model.model, C.CString(attrname), C.int(len(ind)), (*C.int)(&ind[0]), (*C.double)(&value[0]))
	if err != 0 {
		return []float64{}, model.makeError(err)
	}
	return value, nil
}

func (model *Model) setDoubleAttrList(attrname string, ind []int32, value []float64) error {
	if model == nil {
		return errors.New("")
	}
	if len(ind) != len(value) {
		return errors.New("")
	}
	if len(ind) == 0 {
		return nil
	}
	err := C.GRBsetdblattrlist(model.model, C.CString(attrname), C.int(len(ind)), (*C.int)(&ind[0]), (*C.double)(&value[0]))
	if err != 0 {
		return model.makeError(err)
	}
	return nil
}
