package gurobi

import "testing"

/*
TestEnv_NewEnv1
Description:
	Verifies that NewEnv() correctly creates a new environment with log file given.
*/
func TestEnv_NewEnv1(t *testing.T) {
	// Constants
	logfilename1 := "thomTide.log"

	// Algorithm
	env, err := NewEnv(logfilename1)
	if err != nil {
		t.Errorf("There was an issue creating the new Env variable: %v", err)
	}
	defer env.Free()

}

/*
TestEnv_SetTimeLimit1
Description:
	Verifies that NewEnv() correctly creates a new environment with log file given.
*/
func TestEnv_SetTimeLimit1(t *testing.T) {
	// Constants
	logfilename1 := "thomTide.log"
	var newTimeLimit float64 = 132

	// Algorithm
	env, err := NewEnv(logfilename1)
	if err != nil {
		t.Errorf("There was an issue creating the new Env variable: %v", err)
	}
	defer env.Free()

	err = env.SetTimeLimit(newTimeLimit)
	if err != nil {
		t.Errorf("There was an error setting the time limit of the environment! %v", err)
	}

	detectedTimeLimit, err := env.GetTimeLimit()
	if err != nil {
		t.Errorf("There was an error getting the time limit of the environment! %v", err)
	}

	if detectedTimeLimit != newTimeLimit {
		t.Errorf("The detected time limit (%v) was not equal to the expected time limit (%v s).", detectedTimeLimit, newTimeLimit)
	}

}

/*
TestEnv_SetDBLParam1
Description:
	Verifies that we can set the value of 'TimeLimit' in current model.
*/
func TestEnv_SetDBLParam1(t *testing.T) {
	// Constants
	logfilename1 := "thomTide.log"
	var newTimeLimit float64 = 132

	// Algorithm
	env, err := NewEnv(logfilename1)
	if err != nil {
		t.Errorf("There was an issue creating the new Env variable: %v", err)
	}
	defer env.Free()

	err = env.SetDBLParam("TimeLimit", newTimeLimit)
	if err != nil {
		t.Errorf("There was an error setting the time limit of the environment! %v", err)
	}

	detectedTimeLimit, err := env.GetDBLParam("TimeLimit")
	if err != nil {
		t.Errorf("There was an error getting the time limit of the environment! %v", err)
	}

	if detectedTimeLimit != newTimeLimit {
		t.Errorf("The detected time limit (%v) was not equal to the expected time limit (%v s).", detectedTimeLimit, newTimeLimit)
	}

}

/*
TestEnv_SetDBLParam1
Description:
	Verifies that we can set the value of 'Cutoff' in current model.
*/
func TestEnv_SetDBLParam2(t *testing.T) {
	// Constants
	logfilename1 := "thomTide.log"
	var newTimeLimit float64 = 132
	var paramToModify string = "Cutoff"

	// Algorithm
	env, err := NewEnv(logfilename1)
	if err != nil {
		t.Errorf("There was an issue creating the new Env variable: %v", err)
	}
	defer env.Free()

	err = env.SetDBLParam(paramToModify, 1000.5)
	if err != nil {
		t.Errorf("There was an error setting the time limit of the environment! %v", err)
	}

	detectedTimeLimit, err := env.GetDBLParam(paramToModify)
	if err != nil {
		t.Errorf("There was an error getting the time limit of the environment! %v", err)
	}

	if detectedTimeLimit != newTimeLimit {
		t.Errorf("The detected time limit (%v) was not equal to the expected time limit (%v s).", detectedTimeLimit, newTimeLimit)
	}

}
