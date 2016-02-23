#!/usr/bin/bash
ldc2 -c -of=gurobi.obj gurobi/package.d
ldc2 -of=example.exe example.d gurobi.obj $GUROBI_HOME/lib/gurobi65.lib
exit $?
