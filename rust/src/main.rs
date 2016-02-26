extern crate libc;
mod gurobi;

fn main() {
  let env = gurobi::Env::new("model.log");
  let mut model = gurobi::Model::new(&env, "mip1");

  model.add_var(0.0, 1.0, 0.0, 'B', "x");
  model.add_var(0.0, 1.0, 0.0, 'B', "y");
  model.add_var(0.0, 1.0, 0.0, 'B', "z");
  model.update();

  model.add_constr(vec![0, 1, 2], vec![1., 2., 3.], '<', 4.0, "c0");
  model.add_constr(vec![0, 1], vec![1., 2.], '>', 1.0, "c1");

  model.set_objective(vec![1., 1., 2.], -1);

  model.optimize();

  let numvars = model.get_int_attr("NumVars");
  assert!(numvars == 3);

  for i in 0..3 {
    let name = model.get_string_attr_element("VarName", i);
    let val = model.get_double_attr_element("X", i);
    println!("{} = {}", name, val);
  }

  let obj = model.get_double_attr("ObjVal");
  println!("Obj: {}", obj);
}
