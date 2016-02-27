mod gurobi;
use gurobi::*;

impl gurobi::Model {
  fn show_info(&self) {
    println!("---");

    let modelname = self.get_string_attr("ModelName");
    println!("modelname: {}", modelname);

    let status = self.get_int_attr("Status");
    println!("status: {}", status);

    let numvars = self.get_int_attr("NumVars");
    println!("vars:");
    for i in 0..numvars {
      let name = self.get_string_attr_element("VarName", i);
      println!("  - vname: {}", name);

      let val = self.get_double_attr_element("X", i);
      println!("    value: {}", val);
    }

    let objval = self.get_double_attr("ObjVal");
    println!("objval: {}", objval);

    println!("...");
  }
}

fn main() {
  let env = Env::new("model.log");
  let mut model = Model::new(&env, "mip1");

  model.add_var("x", 'B', 0.0, 1.0, 0.0);
  model.add_var("y", 'B', 0.0, 1.0, 0.0);
  model.add_var("z", 'B', 0.0, 1.0, 0.0);
  model.update();

  model.add_constr("c0", vec![0, 1, 2], vec![1., 2., 3.], -4.0, '<');
  model.add_constr("c1", vec![0, 1], vec![1., 2.], -1.0, '>');

  model.set_objective(vec![1., 1., 2.], -1);

  model.optimize();
  model.show_info();
}
