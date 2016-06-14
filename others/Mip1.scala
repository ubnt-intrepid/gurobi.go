import gurobi._
import scala.language.reflectiveCalls

object Mip1
{
  def using[A <: {def dispose(): Unit}, B](param:A)(f: A => B): B = {
    try {
      f(param)
    } finally {
      param.dispose
    }
  }

  def main(args: Array[String])
  {
    try {
      using (new GRBEnv) { env => {
        using (new GRBModel(env)) { model => {

          val x = model.addVar(0.0, 1.0, 0.0, GRB.BINARY, "x")
          val y = model.addVar(0.0, 1.0, 0.0, GRB.BINARY, "y")
          val z = model.addVar(0.0, 1.0, 0.0, GRB.BINARY, "z")
          model.update

          var expr = new GRBLinExpr
          expr.addTerm(1.0, x)
          expr.addTerm(1.0, y)
          expr.addTerm(2.0, z)
          model.setObjective(expr, GRB.MAXIMIZE)

          expr = new GRBLinExpr
          expr.addTerm(1.0, x)
          expr.addTerm(2.0, y)
          expr.addTerm(3.0, z)
          model.addConstr(expr, GRB.LESS_EQUAL, 4.0, "c0")

          expr = new GRBLinExpr
          expr.addTerm(1.0, x)
          expr.addTerm(1.0, y)
          model.addConstr(expr, GRB.GREATER_EQUAL, 1.0, "c1")

          model.optimize

          println(x.get(GRB.StringAttr.VarName) + " " + x.get(GRB.DoubleAttr.X))
          println(y.get(GRB.StringAttr.VarName) + " " + y.get(GRB.DoubleAttr.X))
          println(z.get(GRB.StringAttr.VarName) + " " + z.get(GRB.DoubleAttr.X))

          println("Obj: " + model.get(GRB.DoubleAttr.ObjVal))
        } }
      } }
    } catch {
      case e:GRBException => {
        println("Error code: " + e.getErrorCode)
      }
    }
  }
}
