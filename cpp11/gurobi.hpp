// vim: set ts=2 sw=2 et foldmarker=[[[,]]] :
#pragma once

#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <functional>

extern "C" {
#include "gurobi_c.h"
}


namespace gurobi {

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
      : model(model)
      , index(index)
  {
  }
};

struct LinExpr {
  std::vector<Var> vars;
  std::vector<double> coeff;
  double offset;

public:
  LinExpr(std::vector<Var> vars, std::vector<double> coeff, double offset)
      : vars(vars)
      , coeff(coeff)
      , offset(offset)
  {
    assert(vars.size() == coeff.size());
  }
};

struct temp_constr {
  LinExpr expr;
  char sense;

public:
  temp_constr(LinExpr expr, char sense)
      : expr(expr)
      , sense(sense)
  {
  }
};

class IntAttr {
  char const* name;
public:
  constexpr IntAttr(char const* name)
      : name(name)
  {
  }

  constexpr operator char const*() const { return name; }

  int get(GRBmodel* model, int& value) {
    return ::GRBgetintattr(model, name, &value);
  }

  int set(GRBmodel* model, int newvalue) {
    return ::GRBsetintattr(model, name, newvalue);
  }

  using value_type = int;
};

class DoubleAttr {
  char const* name;
public:
  constexpr DoubleAttr(char const* name)
      : name(name)
  {
  }

  constexpr operator char const*() const { return name; }

  int get(GRBmodel* model, double& value) {
    return ::GRBgetdblattr(model, name, &value);
  }

  int set(GRBmodel* model, double newvalue) {
    return ::GRBsetdblattr(model, name, newvalue);
  }

  using value_type = double;
};

namespace attr {
static constexpr IntAttr ModelSense{"ModelSense"};
static constexpr DoubleAttr ObjVal{"ObjVal"};
static constexpr DoubleAttr X{"X"};
} // namespace attr

class Model {
  GRBmodel* model = nullptr;
  int varcount    = 0;

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
    set_double("Obj", coeff);
    set_int("ModelSense", sense);
  }

  template <typename Attr, typename T>
  void set(Attr attr, T value)
  {
    int ret = attr.set(model, value);
    if (ret) {
      throw std::runtime_error("GRBset");
    }
  }

  template <typename Attr, typename T = typename Attr::value_type>
  T get(Attr attr)
  {
    T value;
    int ret = attr.get(model, std::ref(value));
    if (ret) {
      throw std::runtime_error("GRBget");
    }
    return value;
  }

  void set_double(std::string const& attrname,
                  std::vector<double> newvalues,
                  int offset = 0)
  {
    int ret = ::GRBsetdblattrarray(model, attrname.c_str(), offset,
                                   newvalues.size(), newvalues.data());
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
    std::vector<int> index(constr.expr.vars.size());
    for (int i = 0; i < constr.expr.vars.size(); ++i) {
      index[i] = constr.expr.vars[i].index;
    }

    int ret = ::GRBaddconstr(model, index.size(), index.data(),
                             constr.expr.coeff.data(), constr.sense,
                             -constr.expr.offset, name.c_str());
    if (ret) {
      throw std::runtime_error("GRBaddconstr");
    }
  }

  double get_double(std::string const& attrname)
  {
    double value;
    int ret = ::GRBgetdblattr(model, attrname.c_str(), &value);
    if (ret) {
      throw std::runtime_error("GRBgetdblattr");
    }
    return value;
  }

  double get_double(std::string const& attrname, int index)
  {
    double value;
    int ret = ::GRBgetdblattrelement(model, attrname.c_str(), index, &value);
    if (ret) {
      throw std::runtime_error("GRBgetdblattrelement");
    }
    return value;
  }

  std::string get_str(std::string const& attrname, int index)
  {
    char* value;
    int ret = ::GRBgetstrattrelement(model, attrname.c_str(), index, &value);
    if (ret) {
      throw std::runtime_error("GRBgetstrattrelement");
    }
    return value;
  }

  void set_int(std::string const& attrname, int value)
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

} // namespace gurobi;
