package gurobi

// Gurobi variable object
type Var struct {
	model *Model
	idx   int32
}

func (v *Var) GetInt(attr string) (int32, error) {
	return v.model.getIntAttrElement(attr, v.idx)
}

func (v *Var) GetChar(attr string) (int8, error) {
	return v.model.getCharAttrElement(attr, v.idx)
}

func (v *Var) GetDouble(attr string) (float64, error) {
	return v.model.getDoubleAttrElement(attr, v.idx)
}

func (v *Var) GetString(attr string) (string, error) {
	return v.model.getStringAttrElement(attr, v.idx)
}

func (v *Var) SetInt(attr string, value int32) error {
	return v.model.setIntAttrElement(attr, v.idx, value)
}

func (v *Var) SetChar(attr string, value int8) error {
	return v.model.setCharAttrElement(attr, v.idx, value)
}

func (v *Var) SetDouble(attr string, value float64) error {
	return v.model.setDoubleAttrElement(attr, v.idx, value)
}

func (v *Var) SetString(attr string, value string) error {
	return v.model.setStringAttrElement(attr, v.idx, value)
}
