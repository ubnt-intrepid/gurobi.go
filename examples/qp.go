package main

import "../gurobi"
import "fmt"

func main() {
	// Create environment.
	env, err := gurobi.NewEnv("qp.log")
	if err != nil {
		panic(err.Error())
	}
	defer env.Free()

	// Create an empty model.
	model, err := gurobi.NewModel("qp", env)
	if err != nil {
		panic(err.Error())
	}
	defer model.Free()

	// Add varibles
	x, err := model.AddVar(gurobi.CONTINUOUS, 0.0, 0.0, gurobi.INFINITY, "x", []*gurobi.Constr{}, []float64{})
	if err != nil {
		panic(err.Error())
	}
	y, err := model.AddVar(gurobi.CONTINUOUS, 0.0, 0.0, gurobi.INFINITY, "y", []*gurobi.Constr{}, []float64{})
	if err != nil {
		panic(err.Error())
	}
	z, err := model.AddVar(gurobi.CONTINUOUS, 0.0, 0.0, gurobi.INFINITY, "z", []*gurobi.Constr{}, []float64{})
	if err != nil {
		panic(err.Error())
	}

	// Integrate new variables.
	if err := model.Update(); err != nil {
		panic(err.Error())
	}

	// Quadratic objective terms
	if err := model.AddQPTerms([]*gurobi.Var{x, y, y, z, z}, []*gurobi.Var{x, x, y, y, z}, []float64{1, 1, 1, 1, 1}); err != nil {
		panic(err.Error())
	}

	// Linear objective term
	if err := model.SetDoubleAttrVars(gurobi.DBL_ATTR_OBJ, []*gurobi.Var{x}, []float64{2}); err != nil {
		panic(err.Error())
	}

	// First constraint
	if _, err = model.AddConstr([]*gurobi.Var{x, y, z}, []float64{1, 2, 3}, '>', 4.0, "c0"); err != nil {
		panic(err.Error())
	}

	// Second constraint
	if _, err = model.AddConstr([]*gurobi.Var{x, y, z}, []float64{1, 1, 1}, '>', 1.0, "c1"); err != nil {
		panic(err.Error())
	}

	// Optimize model
	if err := model.Optimize(); err != nil {
		panic(err.Error())
	}

	// Write model to 'qp.lp'.
	if err := model.Write("qp.lp"); err != nil {
		panic(err.Error())
	}

	// Capture solution information
	optimstatus, err := model.GetIntAttr(gurobi.INT_ATTR_STATUS)
	if err != nil {
		panic(err.Error())
	}

	objval, err := model.GetDoubleAttr(gurobi.DBL_ATTR_OBJVAL)
	if err != nil {
		panic(err.Error())
	}

	sol, err := model.GetDoubleAttrVars(gurobi.DBL_ATTR_X, []*gurobi.Var{x, y, z})
	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("\nOptimization complete\n")
	if optimstatus == gurobi.OPTIMAL {
		fmt.Printf("Optimal objective: %.4e\n", objval)
		fmt.Printf("  x=%.4f, y=%.4f, z=%.4f\n", sol[0], sol[1], sol[2])
	} else if optimstatus == gurobi.INF_OR_UNBD {
		fmt.Printf("Model is infeasible or unbounded\n")
	} else {
		fmt.Printf("Optimization was stopped early\n")
	}
}
