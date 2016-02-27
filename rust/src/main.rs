mod gurobi;
use gurobi::{Env, Model};

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
