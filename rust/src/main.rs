mod gurobi;
use gurobi::{Env, Model};

fn main() {
  let env = Env::new("model.log");
  let mut model = Model::new(&env, "mip1");

  model.add_bvar("x", 0.0);
  model.add_bvar("y", 0.0);
  model.add_bvar("z", 0.0);
  model.update();

  model.add_constr(vec![0, 1, 2], vec![1., 2., 3.], '<', 4.0, "c0");
  model.add_constr(vec![0, 1], vec![1., 2.], '>', 1.0, "c1");

  model.set_objective(vec![1., 1., 2.], -1);

  model.optimize();
  model.show_info();
}
