import std.stdio;
import gurobi;

void main()
{
  scope env   = new Env("mip1.log");

  scope model = new Model(env, "mip1");
  model.set(IntAttr.ModelSense, ModelSense.MAXIMIZE);

  model.add_vars(VarType.BINARY, 3, /*obj=*/ [1, 1, 2]);
  model.update();

  auto c0 = new LinTempConstr(new LinExpr([0,1,2], [1,2,3], -4.0), ConstrSense.LESS_EQUAL);
  model.add_constr("c0", c0);

  auto c1 = new LinTempConstr(new LinExpr([0,1], [1,1], -1.0), ConstrSense.GREATER_EQUAL);
  model.add_constr("c1", c1);

  model.optimize();

  const status = model.status();
  assert( status == Status.OPTIMAL );

  const objval = model.get(DoubleAttr.ObjVal);
  const sol    = model.get(DoubleArrayAttr.X);

  writefln("Optimal objective: %6e", objval);
  writefln("  x=%06e y=%06e z=%06e", sol[0], sol[1], sol[2]);

  model.write("mip1.lp");
}
