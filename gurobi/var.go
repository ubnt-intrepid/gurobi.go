package gurobi

// #include <gurobi_c.h>
import "C"

// Gurobi variable object
type Var struct {
	model *Model
	idx   int32
}

func (v *Var) GetDouble(attr string) (float64, error) {
	return v.model.getDoubleAttrElement(attr, v.idx)
}

func (v *Var) SetDouble(attr string, value float64) error {
	return v.model.setDoubleAttrElement(attr, v.idx, value)
}
