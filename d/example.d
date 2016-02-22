import std.stdio;
import std.c.stdlib;
import gurobi.api_c;

void main()
{
  GRBenv   *env;
  GRBmodel *model;

  int       error = 0;
  double    sol[3];
  int       ind[3];
  double    val[3];
  double    obj[3];
  char      vtype[3];
  int       optimstatus;
  double    objval;

  /* Create environment */
  error = GRBloadenv(&env, cast(char*)"mip1.log");
  if (error) goto QUIT;

  /* Create an empty model */

  error = GRBnewmodel(env, &model, cast(char*)"mip1", 0,
          cast(double*)null, cast(double*)null, cast(double*)null,
          cast(char*)null, cast(char**)null);
  if (error) goto QUIT;


  /* Add variables */

  obj[0] = 1; obj[1] = 1; obj[2] = 2;
  vtype[0] = GRB_BINARY; vtype[1] = GRB_BINARY; vtype[2] = GRB_BINARY;
  error = GRBaddvars(model, 3, 0, cast(int*)null, cast(int*)null, cast(double*)null,
                     cast(double*)obj, cast(double*)null, cast(double*)null,
                     cast(char*)vtype, cast(char**)null);
  if (error) goto QUIT;

  /* Change objective sense to maximization */

  error = GRBsetintattr(model, cast(char*)"ModelSense", GRB_MAXIMIZE);
  if (error) goto QUIT;

  /* Integrate new variables */

  error = GRBupdatemodel(model);
  if (error) goto QUIT;


  /* First constraint: x + 2 y + 3 z <= 4 */

  ind[0] = 0; ind[1] = 1; ind[2] = 2;
  val[0] = 1; val[1] = 2; val[2] = 3;

  error = GRBaddconstr(model, 3, cast(int*)ind, cast(double*)val, GRB_LESS_EQUAL, 4.0, cast(char*)"c0");
  if (error) goto QUIT;

  /* Second constraint: x + y >= 1 */

  ind[0] = 0; ind[1] = 1;
  val[0] = 1; val[1] = 1;

  error = GRBaddconstr(model, 2, cast(int*)ind, cast(double*)val, GRB_GREATER_EQUAL, 1.0, cast(char*)"c1");
  if (error) goto QUIT;

  /* Optimize model */

  error = GRBoptimize(model);
  if (error) goto QUIT;

  /* Write model to 'mip1.lp' */

  error = GRBwrite(model, cast(char*)"mip1.lp");
  if (error) goto QUIT;

  /* Capture solution information */

  error = GRBgetintattr(model, cast(char*)"Status", &optimstatus);
  if (error) goto QUIT;

  error = GRBgetdblattr(model, cast(char*)"ObjVal", &objval);
  if (error) goto QUIT;

  error = GRBgetdblattrarray(model, cast(char*)"X", 0, 3, cast(double*)sol);
  if (error) goto QUIT;

  printf("\nOptimization complete\n");
  if (optimstatus == GRB_OPTIMAL) {
    printf("Optimal objective: %.4e\n", objval);

    printf("  x=%.0f, y=%.0f, z=%.0f\n", sol[0], sol[1], sol[2]);
  } else if (optimstatus == GRB_INF_OR_UNBD) {
    printf("Model is infeasible or unbounded\n");
  } else {
    printf("Optimization was stopped early\n");
  }

QUIT:

  /* Error reporting */

  if (error) {
    printf("ERROR: %s\n", GRBgeterrormsg(env));
    exit(1);
  }

  /* Free model */

  GRBfreemodel(model);

  /* Free environment */

  GRBfreeenv(env);

  exit(0);
}
