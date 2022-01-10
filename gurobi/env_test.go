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
