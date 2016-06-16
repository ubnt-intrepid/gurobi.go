mod gurobi;
use gurobi::{Env, Model};

fn create_model(env: &mut Env) -> Result<Model, String> {
  // Create an empty model named "mip1".
  // newModel :: str -> Result<Model, String>
  let mut model = try!(env.newModel("mip1"));

  // Add binary decision variables.
  // add_var :: str -> f64 -> Result<Var, String>
  let x = try!(model.add_bvar("x", 0.0));
  let y = try!(model.add_bvar("y", 0.0));
  let z = try!(model.add_bvar("z", 0.0));

  // Integrate variables into model.
  try!(model.update());

  // Add constraints to model
  // add_var :: str -> f64 -> Result<Constr, String>
  let c1 =
    try!(model.add_constr(vec![0, 1, 2], vec![1., 2., 3.], '<', 4.0, "c1"));
  let c2 = try!(model.add_constr(vec![0, 1], vec![1., 2.], '>', 1.0, "c2"));

  // Set objective function of the model.
  try!(model.set_objective(vec![1., 1., 2.], -1));

  // returns constructed model if successed.
  Ok(model)
}

fn main() {
  let mut env = Env::new("model.log").unwrap();
  let mut model = create_model(&mut env).unwrap();

  // optimize :: () => Result<Model, String>
  match model.optimize() {
    Err(err) => panic!("An error was occurred at optimization step: {}", err),
  }

  // show_info :: () => Model
  model.show_info();
}
