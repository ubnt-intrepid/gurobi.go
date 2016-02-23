import std.stdio;
import std.c.stdlib;

import gurobi.api_c;


scope class Env
{
  GRBenv* env;

public:
  this(string logfilename)
  {
    int error = GRBloadenv(&env, cast(char*)logfilename);
    if (error)
      throw new Exception("cannot load environment");
  }

  ~this()
  {
    // Free environment
    GRBfreeenv(env);
  }

  GRBenv* get() { return env; }
}


scope class Model
{
  GRBmodel* model;

  void failure()
  {
    GRBenv* env = GRBgetenv(model);
    assert(env != null);
    throw new Exception("ERROR: GUROBI");
  }

public:
  this(GRBmodel* model)
  {
    this.model = model;
  }

  this(Env env, string modelname)
  {
    GRBmodel* model;
    int error = GRBnewmodel(env.get(), &model, cast(char*)modelname, 0,
                            cast(double*)null, cast(double*)null,
                            cast(double*)null, cast(char*)null,
                            cast(char**)null);
    if (error)
      throw new Exception("ERROR: GUROBI");

    this(model);
  }

  ~this()
  {
    // Free model
    GRBfreemodel(model);
  }

  int getintattr(string attr)
  {
    int val;
    int error = GRBgetintattr(model, cast(char*)attr, &val);
    if (error)
      failure();
    return val;
  }

  double getdblattr(string attr)
  {
    double val;
    int error = GRBgetdblattr(model, cast(char*)attr, &val);
    if (error)
      failure();
    return val;
  }

  double[] getdblattrarray(string attr, int length)
  {
    double[] val = new double[length];
    int error = GRBgetdblattrarray(model, cast(char*)attr, 0, length, cast(double*)val);
    if (error)
      failure();
    return val;
  }

  void setintattr(string attr, int value)
  {
    int error = GRBsetintattr(model, cast(char*)attr, value);
    if (error)
      failure();
  }

  void addvars(char[] vtype, double[] obj)
  in {
    assert(obj.length == vtype.length);
  }
  body {
    int error = GRBaddvars(model, cast(int)obj.length, 0, cast(int*)null, cast(int*)null,
                           cast(double*)null, cast(double*)obj,
                           cast(double*)null, cast(double*)null,
                           cast(char*)vtype, cast(char**)null);
    if (error)
      failure();
  }

  void addvars(char vtype, int length, double[] obj)
  in {
    assert(obj.length == length);
  }
  body {
    char[] vtypes = new char[length];
    vtypes[] = vtype;
    addvars(vtypes, obj);
  }

  void addvars(char vtype, int length)
  {
    char[] vtypes = new char[length];
    double[] obj  = new double[length];
    vtypes[] = vtype;
    obj[] = 0;
    addvars(vtypes, obj);
  }

  void addconstr(int[] ind, double[] val, char sense, double rhs, string cname)
  in {
    assert(ind.length == val.length);
  }
  body {
    int error = GRBaddconstr(model, cast(int)ind.length, cast(int*)ind, cast(double*)val,
                             sense, rhs, cast(char*)cname);
    if (error)
      failure();
  }

  void update()
  {
    int error = GRBupdatemodel(model);
    if (error)
      failure();
  }

  void optimize()
  {
    int error = GRBoptimize(model);
    if (error)
      failure();
  }

  void write(string filename)
  {
    int error = GRBwrite(model, cast(char*)filename);
    if (error)
      failure();
  }
}


void main()
{
  // Create environment
  scope env = new Env("mip1.log");

  // Create an empty model
  scope model = new Model(env, "mip1");;

  // Add variables
  model.addvars(GRB_BINARY, 3, /*obj=*/[1, 1, 2]);
  //model.addvars(GRB_BINARY, 3);

  // Change objective sense to maximization
  model.setintattr("ModelSense", GRB_MAXIMIZE);

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
  int optimstatus = model.getintattr("Status");
  double objval   = model.getdblattr("ObjVal");
  double[] sol    = model.getdblattrarray("X", 3);

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
