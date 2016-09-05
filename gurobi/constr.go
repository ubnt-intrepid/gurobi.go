package gurobi

// #include <gurobi_c.h>
import "C"

// Gurobi linear constraint object
type Constr struct {
	model *Model
	idx   int32
}
