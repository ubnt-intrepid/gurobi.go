import std.stdio;
import std.c.stdlib;

import gurobi.api_c;

// Error reporting
void failure(GRBenv* env)
{
  throw new Exception("ERROR: GUROBI");
}

GRBenv* loadenv(string logfilename)
{
  GRBenv* env;
  int error = GRBloadenv(&env, cast(char*)logfilename);
  if (error)
    throw new Exception("cannot load environment");
  return env;
}

GRBmodel* newmodel(GRBenv* env, string modelname)
{
  GRBmodel* model;
  int error = GRBnewmodel(env, &model, cast(char*)modelname, 0,
                          cast(double*)null, cast(double*)null,
                          cast(double*)null, cast(char*)null,
                          cast(char**)null);
  if (error)
    failure(env);
  return model;
}

  int getintattr(GRBmodel* model, string attr)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int val;
  int error = GRBgetintattr(model, cast(char*)attr, &val);
  if (error)
    failure(env);

  return val;
}

double getdblattr(GRBmodel* model, string attr)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  double val;
  int error = GRBgetdblattr(model, cast(char*)attr, &val);
  if (error)
    failure(env);

  return val;
}

double[] getdblattrarray(GRBmodel* model, string attr, int length)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  double[] val = new double[length];
  int error = GRBgetdblattrarray(model, cast(char*)attr, 0, length, cast(double*)val);
  if (error)
    failure(env);

  return val;
}

void setintattr(GRBmodel* model, string attr, int value)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBsetintattr(model, cast(char*)attr, value);
  if (error)
    failure(env);
}

void addvars(GRBmodel* model, double[] obj, char[] vtype)
{
  assert(obj.length == vtype.length);

  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBaddvars(model, cast(int)obj.length, 0, cast(int*)null, cast(int*)null,
                         cast(double*)null, cast(double*)obj,
                         cast(double*)null, cast(double*)null,
                         cast(char*)vtype, cast(char**)null);
  if (error)
    failure(env);
}

void addconstr(GRBmodel* model, int[] ind, double[] val, char sense, double rhs,
               string cname)
{
  assert(ind.length == val.length);

  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBaddconstr(model, cast(int)ind.length, cast(int*)ind, cast(double*)val,
                           sense, rhs, cast(char*)cname);
  if (error)
    failure(env);
}

void updatemodel(GRBmodel* model)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBupdatemodel(model);
  if (error)
    failure(env);
}

void optimize(GRBmodel* model)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBoptimize(model);
  if (error)
    failure(env);
}

void write(GRBmodel* model, string filename)
{
  GRBenv* env = GRBgetenv(model);
  assert(env != null);

  int error = GRBwrite(model, cast(char*)filename);
  if (error)
    failure(env);
}

void main()
{
  // Create environment
  GRBenv* env = loadenv("mip1.log");
  scope(exit) {
    GRBfreeenv(env);  // Free environment
  }

  // Create an empty model
  GRBmodel* model = newmodel(env, "mip1");;
  scope(exit) {
    GRBfreemodel(model);  // Free model
  }

  // Add variables
  addvars(model, [1, 1, 2], [GRB_BINARY, GRB_BINARY, GRB_BINARY]);

  // Change objective sense to maximization
  setintattr(model, "ModelSense", GRB_MAXIMIZE);

  // Integrate new variables
  updatemodel(model);

  // First constraint: x + 2 y + 3 z <= 4
  addconstr(model, [0, 1, 2], [1, 2, 3], GRB_LESS_EQUAL, 4.0, "c0");

  // Second constraint: x + y >= 1
  addconstr(model, [0, 1], [1, 1], GRB_GREATER_EQUAL, 1.0, "c1");

  // Optimize model
  optimize(model);

  // Write model to 'mip1.lp'
  write(model, "mip1.lp");

  // Capture solution information
  int optimstatus = getintattr(model, "Status");
  double objval   = getdblattr(model, "ObjVal");
  double[] sol    = getdblattrarray(model, "X", 3);

  writeln();
  writeln("Optimization complete");

  if (optimstatus == GRB_OPTIMAL)
  {
    writeln("Optimal objective: ", objval);
    writeln("  x=", sol[0], ", y=", sol[1], ", z=", sol[2]);
  }
  else if (optimstatus == GRB_INF_OR_UNBD) {
    writeln("Model is infeasible or unbounded");
  }
  else {
    writeln("Optimization was stopped early");
  }
}
