// $ g++ -std=c++11 main.cpp -lgurobi65 && ./a
// vim: set ts=2 sw=2 et foldmarker=[[[,]]] :

#include <iostream>
#include "gurobi.hpp"

int main(int argc, char const* argv[])
{
  using namespace std;
  using namespace gurobi;

  Env env("mip1.log");
  Model model(env);

  auto x = model.add_var("x", binary{});
  auto y = model.add_var("y", binary{});
  auto z = model.add_var("z", integer{0, 1});
  auto t = model.add_var("t", real{0});
  model.update();

  model.add_constr("c0", {{{x, y, z}, {1, 2, 3}, -4}, '<'});
  model.add_constr("c1", {{{x, y}, {1, 2}, -1}, '>'});
  model.add_constr("c2", {{{x, y, z, t}, {1, 1.2, 2.5, -1}, 0}, '='});

  model.set_objective({1, 1, 2, 2}, -1);

  model.optimize();

  for (int i = 0; i < 4; ++i) {
    auto vname = model.get_str("VarName", i);
    auto value = model.get_double("X", i);
    cout << vname << " = " << value << endl;
  }

  double obj = model.get(attr::ObjVal);
  cout << "Obj = " << obj << endl;
}
