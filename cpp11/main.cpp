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

class Model;

struct Var {
  Model& model;
  int index;
public:
  Var(Model& model, int index)
    : model(model), index(index)
  {
  }
};


struct temp_constr {
  std::vector<Var>    vars;
  std::vector<double> coeff;
  char                sense;
  double              rhs;
public:
  temp_constr(std::vector<Var> vars, std::vector<double> coeff,
              char sense, double rhs = 0.0)
    : vars(vars), coeff(coeff), sense(sense), rhs(rhs)
  {
    assert(vars.size() == coeff.size());
  }
};


class Model {
  GRBmodel* model = nullptr;
  int varcount = 0;

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

  void set_objective(std::vector<double> coeff, int sense)
  {
    set_double_attrs("Obj", coeff);
    set_int_attr("ModelSense", sense);
  }

  void set_double_attrs(std::string const& attrname, std::vector<double> newvalues)
  {
    int ret = ::GRBsetdblattrarray(model, attrname.c_str(), 0, newvalues.size(),
                                   newvalues.data());
    if (ret) {
      throw std::runtime_error("GRBsetintattr");
    }
  }

  template <typename VarType>
  Var add_var(std::string const& name, VarType vtype, double obj = 0.0)
  {
    int ret = ::GRBaddvar(model, 0, nullptr, nullptr, obj, vtype.lb(),
                          vtype.ub(), vtype.vtype(), name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddvar");
    }
    return Var(*this, varcount++);
  }

  void add_constr(std::string const& name, temp_constr constr)
  {
    std::vector<int> index(constr.vars.size());
    for (int i = 0 ; i < constr.vars.size(); ++i) {
      index[i] = constr.vars[i].index;
    }

    int ret = ::GRBaddconstr(model, index.size(), index.data(),
                             constr.coeff.data(), constr.sense,
                             constr.rhs, name.c_str());
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
  int _lb;
  int _ub;

public:
  constexpr integer(int lb = -100000, int ub = 100000)
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

  auto x = model.add_var("x", binary{});
  auto y = model.add_var("y", binary{});
  auto z = model.add_var("z", binary{});
  auto t = model.add_var("t", integer{});
  model.update();

  model.add_constr("c0", {{x, y, z},    {1, 2, 3},     '<', 4.0});
  model.add_constr("c1", {{x, y},       {1, 2},        '>', 1.0});
  model.add_constr("c2", {{x, y, z, t}, {1, 1, 1, -1}, '=', 0.0});

  model.set_objective({1, 1, 2, 2}, -1);

  model.optimize();
  for (int i = 0; i < 4; ++i) {
    auto vname = model.get_str_attr("VarName", i);
    auto value = model.get_double_attr("X", i);
    cout << vname << " = " << value << endl;
  }

  double obj = model.get_double_attr("ObjVal");
  cout << "Obj = " << obj << endl;
}
