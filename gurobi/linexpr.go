package gurobi

// #include <gurobi_c.h>
import "C"

// Linear expression of variables
type LinExpr struct {
	vars   []*Var
	coeffs []float64
	offset float64
}

func (expr *LinExpr) AddTerm(v *Var, c float64) *LinExpr {
	expr.vars = append(expr.vars, v)
	expr.coeffs = append(expr.coeffs, c)
	return expr
}

func (expr *LinExpr) AddConstant(c float64) *LinExpr {
	expr.offset += c
	return expr
}
