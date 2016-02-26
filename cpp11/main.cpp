// vim: set ts=2 sw=2 et :

#include <iostream>
#include <string>
#include <vector>
#include <cassert>

extern "C" {
#include "gurobi_c.h"
}


class Env {
  friend class Model;
  GRBenv* env = nullptr;
public:
  Env(std::string const& logfilename = "") {
    int ret = ::GRBloadenv(&env, logfilename.c_str());
    if (ret) {
      throw std::runtime_error("gurobi");
    }
  }
  ~Env() {
    ::GRBfreeenv(env);
  }
};


class Model {
  GRBmodel* model = nullptr;
public:
  Model(Env& env, std::string const& modelname = "") {
    int ret = ::GRBnewmodel(env.env, &model, modelname.c_str(),
                            0, nullptr, nullptr, nullptr, nullptr, nullptr);
    if (ret) {
      throw std::runtime_error("GRBnewmodel");
    }
  }

  ~Model() {
    ::GRBfreemodel(model);
  }

  void update() {
    int ret = ::GRBupdatemodel(model);
    if (ret) {
      throw std::runtime_error("GRBupdatemodel");
    }
  }

  void optimize() {
    int ret = ::GRBoptimize(model);
    if (ret) {
      throw std::runtime_error("GRBoptimize");
    }
  }

  void add_var(char vtype, std::string const& name,
               double lb, double ub, double obj = 0.0)
  {
    int ret = ::GRBaddvar(model, 0, nullptr, nullptr, obj, lb, ub,
                          vtype, name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddvar");
    }
  }

  void add_constr(std::string const& name,
                  std::vector<int> cind, std::vector<double> cval,
                  char sense, double rhs)
  {
    assert(cind.size() == cval.size());
    int ret = ::GRBaddconstr(model, cind.size(), cind.data(), cval.data(),
                             sense, rhs, name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddconstr");
    }
  }

  void set_int_attr(std::string const& attrname, int value) {
    int ret = ::GRBsetintattr(model, attrname.c_str(), value);
    if (ret) {
      throw std::runtime_error("GRBsetintattr");
    }
  }
};


int main(int argc, char const* argv[])
{
  Env env;
  Model model(env);

  model.add_var('B', "x", 0.0, 1.0, 1.0);
  model.add_var('B', "y", 0.0, 1.0, 1.0);
  model.add_var('B', "z", 0.0, 1.0, 2.0);
  model.update();

  model.add_constr("c0", {0, 1, 2}, {1, 2, 3}, '<', 4.0);
  model.add_constr("c1", {0, 1}, {1, 2}, '>', 1.0);

  model.set_int_attr("ModelSense", -1);
  // model.set_objective({ 1, 1, 2 }, -1);

  model.optimize();

  return 0;
}
