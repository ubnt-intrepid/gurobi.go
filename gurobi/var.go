package gurobi

// #include <gurobi_c.h>
import "C"

// Gurobi variable object
type Var struct {
	model *Model
	idx   int32
}
