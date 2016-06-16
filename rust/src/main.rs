mod gurobi;
use gurobi::{Env, Model};

fn create_model(env: &mut Env) -> Result<Model, String> {
  let mut model = try!(env.newModel("mip1"));

  model.add_bvar("x", 0.0);
  model.add_bvar("y", 0.0);
  model.add_bvar("z", 0.0);
  model.update();

  model.add_constr(vec![0, 1, 2], vec![1., 2., 3.], '<', 4.0, "c0");
  model.add_constr(vec![0, 1], vec![1., 2.], '>', 1.0, "c1");

  model.set_objective(vec![1., 1., 2.], -1);

  Ok(model)
}

fn main() {
  let mut env = Env::new("model.log").unwrap();
  let mut model = create_model(&mut env).unwrap();
  model.optimize();
  model.show_info();
}
