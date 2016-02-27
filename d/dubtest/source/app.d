import std.stdio;
import std.c.stdlib;
import gurobi;

void main()
{
  // Create environment
  scope env = new Env("mip1.log");

  // Create an empty model
  scope model = new Model(env, "mip1");

  // Add variables
  model.addvars(GRB_BINARY, 3, /*obj=*/ [1, 1, 2]);
  //model.addvars(GRB_BINARY, 3);

  // Change objective sense to maximization
  model.setintattr(GRB_INT_ATTR_MODELSENSE, GRB_MAXIMIZE);

  // Integrate new variables
  model.update();

  // First constraint: x + 2 y + 3 z <= 4
  model.addconstr([0, 1, 2], [1, 2, 3], GRB_LESS_EQUAL, 4.0, "c0");

  // Second constraint: x + y >= 1
  model.addconstr([0, 1], [1, 1], GRB_GREATER_EQUAL, 1.0, "c1");

  // Optimize model
  model.optimize();

  // Write model to 'mip1.lp'
  model.write("mip1.lp");

  // Capture solution information
  int optimstatus = model.getintattr(GRB_INT_ATTR_STATUS);
  double objval = model.getdblattr(GRB_DBL_ATTR_OBJVAL);
  double[] sol = model.getdblattrarray(GRB_DBL_ATTR_X, 3);

  writeln();
  writeln("Optimization complete");

  if (optimstatus == GRB_OPTIMAL)
  {
    writeln("Optimal objective: ", objval);
    writeln("  x=", sol[0], ", y=", sol[1], ", z=", sol[2]);
  }
  else if (optimstatus == GRB_INF_OR_UNBD)
  {
    writeln("Model is infeasible or unbounded");
  }
  else
  {
    writeln("Optimization was stopped early");
  }
}
