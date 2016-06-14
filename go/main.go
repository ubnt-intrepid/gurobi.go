package main

import "./gurobi"
import "fmt"

func main() {
	// Create environment.
	env, err := gurobi.NewEnv("qp.log")
	if err != nil {
		panic(err.Error())
	}
	defer func() {
		env.Free()
		env = nil
	}()

	// Create an empty model.
	model, err := env.NewModel("qp")
	if err != nil {
		panic(err.Error())
	}
	defer func() {
		model.Free()
		model = nil
	}()

	// Add varibles
	if err := model.AddVars(3); err != nil {
		err.Error()
		return
	}

	// Integrate new variables.
	if err := model.Update(); err != nil {
		err.Error()
		return
	}

	// Quadratic objective terms
	if err := model.AddQPTerms([]int32{0, 1, 1, 2, 2}, []int32{0, 0, 1, 1, 2}, []float64{1, 1, 1, 1, 1}); err != nil {
		err.Error()
		return
	}

	// Linear objective term
	if err := model.SetDoubleAttrElement(gurobi.DBL_ATTR_OBJ, 0, 2.0); err != nil {
		err.Error()
		return
	}

	// First constraint
	if err := model.AddConstr([]int32{0, 1, 2}, []float64{1, 2, 3}, '>', 4.0, "c0"); err != nil {
		err.Error()
		return
	}

	// Second constraint
	if err := model.AddConstr([]int32{0, 1, 2}, []float64{1, 1, 1}, '>', 1.0, "c1"); err != nil {
		err.Error()
		return
	}

	// Optimize model
	if err := model.Optimize(); err != nil {
		err.Error()
		return
	}

	// Write model to 'qp.lp'.
	if err := model.Write("qp.lp"); err != nil {
		err.Error()
		return
	}

	// Capture solution information
	optimstatus, err := model.GetIntAttr(gurobi.INT_ATTR_STATUS)
	if err != nil {
		err.Error()
		return
	}

	objval, err := model.GetDoubleAttr(gurobi.DBL_ATTR_OBJVAL)
	if err != nil {
		err.Error()
		return
	}

	sol, err := model.GetDoubleAttrArray(gurobi.DBL_ATTR_X, 3)
	if err != nil {
		err.Error()
		return
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
