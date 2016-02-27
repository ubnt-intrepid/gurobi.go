import std.stdio;
import std.c.stdlib;
import gurobi;

void main()
{
  scope env   = new Env("mip1.log");
  scope model = new Model(env, "mip1");

  model.add_vars(GRB_BINARY, 3, /*obj=*/ [1, 1, 2]);
  model.update();

  model.set_int_attr("ModelSense", -1);

  model.add_constr("c0", [0, 1, 2], [1, 2, 3], '<', 4.0);
  model.add_constr("c1", [0, 1], [1, 1], '>', 1.0);

  model.optimize();

  const objval = model.get_double_attr(GRB_DBL_ATTR_OBJVAL);
  const sol    = model.get_double_attrs(GRB_DBL_ATTR_X, 3);

  writefln("Optimal objective: %6e", objval);
  writefln("  x=%06e y=%06e z=%06e", sol[0], sol[1], sol[2]);

  model.write("mip1.lp");
}
