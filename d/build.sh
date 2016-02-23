#!/usr/bin/bash
ldc2 -of=example.exe example.d $GUROBI_HOME/lib/gurobi65.lib
exit $?
