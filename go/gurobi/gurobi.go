package gurobi

// #include <gurobi_c.h>
// #cgo LDFLAGS: -lgurobi56
import "C"

const DBL_ATTR_OBJ = C.GRB_DBL_ATTR_OBJ
const INT_ATTR_STATUS = C.GRB_INT_ATTR_STATUS
const DBL_ATTR_OBJVAL = C.GRB_DBL_ATTR_OBJVAL
const DBL_ATTR_X = C.GRB_DBL_ATTR_X

const OPTIMAL = C.GRB_OPTIMAL
const INF_OR_UNBD = C.GRB_INF_OR_UNBD
