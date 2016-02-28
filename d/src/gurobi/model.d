module model;

private import api_c;
private import env;



class LinExpr
{
    int[] ind;
    double[] val;
    double offset;

    this(int[] ind, double[] val, double offset)
    in {
        assert(ind.length == val.length);
    }
    body {
        this.ind = ind;
        this.val = val;
        this.offset = offset;
    }
}

class LinTempConstr
{
    LinExpr expr;
    char sense;

    this(LinExpr expr, char sense)
    {
        this.expr = expr;
        this.sense = sense;
    }
}


class Model
{
  private GRBmodel* model;

  private void failure()
  {
    GRBenv* env = GRBgetenv(model);
    assert(env != null);
    throw new Exception("ERROR: GUROBI");
  }

  this(GRBmodel* model)
  {
    this.model = model;
  }

  this(Env env, string modelname)
  {
    GRBmodel* model;
    int error = GRBnewmodel(env.get(), &model, cast(char*) modelname, 0,
      cast(double*) null, cast(double*) null, cast(double*) null,
      cast(char*) null, cast(char**) null);
    if (error)
      throw new Exception("ERROR: GUROBI");

    this(model);
  }

  ~this()
  {
    // Free model
    GRBfreemodel(model);
  }

  Status status()
  {
      return cast(Status) get_int_attr("Status");
  }

  int get_int_attr(string attr)
  {
    int val;
    int error = GRBgetintattr(model, cast(char*) attr, &val);
    if (error)
      failure();
    return val;
  }

  double get_double_attr(string attr)
  {
    double val;
    int error = GRBgetdblattr(model, cast(char*) attr, &val);
    if (error)
      failure();
    return val;
  }

  double[] get_double_attrs(string attr, int length)
  {
    double[] val = new double[length];
    int error = GRBgetdblattrarray(model,
                                   cast(char*) attr,
                                   0,
                                   length,
                                   cast(double*) val);
    if (error)
      failure();
    return val;
  }

  int get(IntAttr attr) {
      return get_int_attr(attr);
  }

  double get(DoubleAttr attr) {
      return get_double_attr(attr);
  }

  void set(IntAttr attr, int value) {
      set_int_attr(attr, value);
  }

  void set(DoubleAttr attr, double value) {
      set_double_attr(attr, value);
  }

  double[] get(DoubleArrayAttr attr) {
      int numvars = get_int_attr(attr[1]);
      double[] val = new double[numvars];
      int error = GRBgetdblattrarray(model, cast(char*) attr[0], 0, numvars,
                                     cast(double*)&val[0]);
      if (error) failure();
      return val;
  }

  void set_int_attr(string attr, int value)
  {
    int error = GRBsetintattr(model, cast(char*) attr, value);
    if (error)
      failure();
  }

  void set_double_attr(string attr, double value)
  {
    int error = GRBsetdblattr(model, cast(char*) attr, value);
    if (error)
      failure();
  }

  void add_vars(char[] vtype, double[] obj)
  in
  {
    assert(obj.length == vtype.length);
  }
  body
  {
    int error = GRBaddvars(model,
                           cast(int) obj.length,
                           0,
                           cast(int*) null,
                           cast(int*) null,
                           cast(double*) null,
                           cast(double*) obj,
                           cast(double*) null,
                           cast(double*) null,
                           cast(char*) vtype,
                           cast(char**) null);
    if (error)
      failure();
  }

  void add_vars(char vtype, int length, double[] obj)
  in
  {
    assert(obj.length == length);
  }
  body
  {
    char[] vtypes = new char[length];
    vtypes[] = vtype;
    add_vars(vtypes, obj);
  }

  void add_constr(string cname, LinTempConstr constr)
  {
    int error = GRBaddconstr(model,
                             cast(int) constr.expr.ind.length,
                             cast(int*) constr.expr.ind,
                             cast(double*) constr.expr.val,
                             constr.sense,
                             -constr.expr.offset,
                             cast(char*) cname);
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
    int error = GRBwrite(model, cast(char*) filename);
    if (error)
      failure();
  }
}
