// $ g++ -std=c++11 main.cpp -lgurobi65 && ./a
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
  Env(std::string const& logfilename = "")
  {
    int ret = ::GRBloadenv(&env, logfilename.c_str());
    if (ret) {
      throw std::runtime_error("gurobi");
    }
  }
  ~Env() { ::GRBfreeenv(env); }
};

class Model {
  GRBmodel* model = nullptr;

public:
  Model(Env& env, std::string const& modelname = "")
  {
    int ret = ::GRBnewmodel(env.env, &model, modelname.c_str(), 0, nullptr,
                            nullptr, nullptr, nullptr, nullptr);
    if (ret) {
      throw std::runtime_error("GRBnewmodel");
    }
  }

  ~Model() { ::GRBfreemodel(model); }

  void update()
  {
    int ret = ::GRBupdatemodel(model);
    if (ret) {
      throw std::runtime_error("GRBupdatemodel");
    }
  }

  void optimize()
  {
    int ret = ::GRBoptimize(model);
    if (ret) {
      throw std::runtime_error("GRBoptimize");
    }
  }

  template <typename VarType>
  void add_var(std::string const& name, VarType vtype, double obj = 0.0)
  {
    int ret = ::GRBaddvar(model, 0, nullptr, nullptr, obj, vtype.lb(),
                          vtype.ub(), vtype.vtype(), name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddvar");
    }
  }

  void add_constr(std::string const& name,
                  std::vector<int> cind,
                  std::vector<double> cval,
                  char sense,
                  double rhs)
  {
    assert(cind.size() == cval.size());
    int ret = ::GRBaddconstr(model, cind.size(), cind.data(), cval.data(),
                             sense, rhs, name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddconstr");
    }
  }

  double get_double_attr(std::string const& attrname)
  {
    double value;
    int ret = ::GRBgetdblattr(model, attrname.c_str(), &value);
    if (ret) {
      throw std::runtime_error("GRBgetdblattr");
    }
    return value;
  }

  double get_double_attr(std::string const& attrname, int index)
  {
    double value;
    int ret = ::GRBgetdblattrelement(model, attrname.c_str(), index, &value);
    if (ret) {
      throw std::runtime_error("GRBgetdblattrelement");
    }
    return value;
  }

  std::string get_str_attr(std::string const& attrname, int index)
  {
    char* value;
    int ret = ::GRBgetstrattrelement(model, attrname.c_str(), index, &value);
    if (ret) {
      throw std::runtime_error("GRBgetstrattrelement");
    }
    return value;
  }

  void set_int_attr(std::string const& attrname, int value)
  {
    int ret = ::GRBsetintattr(model, attrname.c_str(), value);
    if (ret) {
      throw std::runtime_error("GRBsetintattr");
    }
  }
};

struct binary {
public:
  constexpr double lb() const { return 0.0; }
  constexpr double ub() const { return 1.0; }
  constexpr char vtype() const { return 'B'; }
};

struct integer {
  int _lb = -10000;
  int _ub = 10000;

public:
  constexpr integer(int lb, int ub)
      : _lb(lb)
      , _ub(ub)
  {
  }
  constexpr double lb() const { return _lb; }
  constexpr double ub() const { return _ub; }
  constexpr char vtype() const { return 'I'; }
};

int main(int argc, char const* argv[])
{
  using namespace std;

  Env env("mip1.log");
  Model model(env);

  model.add_var("x", binary{}, 1);
  model.add_var("y", binary{}, 1);
  model.add_var("z", binary{}, 2);
  model.add_var("t", integer{-1000, 1000}, 2);
  model.update();

  model.add_constr("c0", {0, 1, 2}, {1, 2, 3}, '<', 4.0);
  model.add_constr("c1", {0, 1}, {1, 2}, '>', 1.0);
  model.add_constr("c2", {0, 1, 2, 3}, {1, 1, 1, -1}, '=', 0.0);

  model.set_int_attr("ModelSense", -1);
  // model.set_objective({ 1, 1, 2 }, -1);

  model.optimize();
  for (int i = 0; i < 4; ++i) {
    auto vname = model.get_str_attr("VarName", i);
    auto value = model.get_double_attr("X", i);
    cout << vname << " = " << value << endl;
  }

  double obj = model.get_double_attr("ObjVal");
  cout << "Obj = " << obj << endl;
}
