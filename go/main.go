package main

import "./gurobi"
import "fmt"

func main() {
	// Create environment.
	env, err := gurobi.NewEnv("qp.log")
	if err != 0 {
		return
	}
	defer env.Free()

	// Create an empty model.
	model, err := env.NewModel("qp")
	if err != 0 {
		env.Error()
		return
	}
	defer model.Free()

	// Add varibles
	err = model.AddVars(3)
	if err != 0 {
		env.Error()
		return
	}

	// Integrate new variables.
	err = model.Update()
	if err != 0 {
		env.Error()
		return
	}

	// Quadratic objective terms
	err = model.AddQPTerms([]int32{0, 1, 1, 2, 2}, []int32{0, 0, 1, 1, 2}, []float64{1, 1, 1, 1, 1})
	if err != 0 {
		env.Error()
		return
	}

	// Linear objective term
	err = model.SetDoubleAttrElement(gurobi.DBL_ATTR_OBJ, 0, 2.0)
	if err != 0 {
		env.Error()
		return
	}

	// First constraint
	err = model.AddConstr([]int32{0, 1, 2}, []float64{1, 2, 3}, '>', 4.0, "c0")
	if err != 0 {
		env.Error()
		return
	}

	// Second constraint
	err = model.AddConstr([]int32{0, 1, 2}, []float64{1, 1, 1}, '>', 1.0, "c1")
	if err != 0 {
		env.Error()
		return
	}

	// Optimize model
	err = model.Optimize()
	if err != 0 {
		env.Error()
		return
	}

	// Write model to 'qp.lp'.
	err = model.Write("qp.lp")
	if err != 0 {
		env.Error()
		return
	}

	// Capture solution information
	optimstatus, err := model.GetIntAttr(gurobi.INT_ATTR_STATUS)
	if err != 0 {
		env.Error()
		return
	}

	objval, err := model.GetDoubleAttr(gurobi.DBL_ATTR_OBJVAL)
	if err != 0 {
		env.Error()
		return
	}

	sol, err := model.GetDoubleAttrArray(gurobi.DBL_ATTR_X, 3)
	if err != 0 {
		env.Error()
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
