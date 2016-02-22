// vim: set ft=d ts=2 sw=2 et :
module attributes;
/* Model attributes */
//C     #define GRB_INT_ATTR_NUMCONSTRS    "NumConstrs"    /* # of constraints */
//C     #define GRB_INT_ATTR_NUMVARS       "NumVars"       /* # of vars */
//C     #define GRB_INT_ATTR_NUMSOS        "NumSOS"        /* # of sos constraints */
//C     #define GRB_INT_ATTR_NUMQCONSTRS   "NumQConstrs"   /* # of quadratic constraints */
//C     #define GRB_INT_ATTR_NUMNZS        "NumNZs"        /* # of nz in A */
//C     #define GRB_DBL_ATTR_DNUMNZS       "DNumNZs"       /* # of nz in A */
//C     #define GRB_INT_ATTR_NUMQNZS       "NumQNZs"       /* # of nz in Q */
//C     #define GRB_INT_ATTR_NUMQCNZS      "NumQCNZs"      /* # of nz in q constraints */
//C     #define GRB_INT_ATTR_NUMINTVARS    "NumIntVars"    /* # of integer vars */
//C     #define GRB_INT_ATTR_NUMBINVARS    "NumBinVars"    /* # of binary vars */
//C     #define GRB_INT_ATTR_NUMPWLOBJVARS "NumPWLObjVars" /* # of variables with PWL obj. */
//C     #define GRB_STR_ATTR_MODELNAME     "ModelName"     /* model name */
//C     #define GRB_INT_ATTR_MODELSENSE    "ModelSense"    /* 1=min, -1=max */
//C     #define GRB_DBL_ATTR_OBJCON        "ObjCon"        /* Objective constant */
//C     #define GRB_INT_ATTR_IS_MIP        "IsMIP"         /* Is model a MIP? */
//C     #define GRB_INT_ATTR_IS_QP         "IsQP"          /* Model has quadratic obj? */
//C     #define GRB_INT_ATTR_IS_QCP        "IsQCP"         /* Model has quadratic constr? */
//C     #define GRB_STR_ATTR_SERVER        "Server"        /* Name of compute server */

/* Variable attributes */
//C     #define GRB_DBL_ATTR_LB             "LB"              /* Lower bound */
//C     #define GRB_DBL_ATTR_UB             "UB"              /* Upper bound */
//C     #define GRB_DBL_ATTR_OBJ            "Obj"             /* Objective coeff */
//C     #define GRB_CHAR_ATTR_VTYPE         "VType"           /* Integrality type */
//C     #define GRB_DBL_ATTR_START          "Start"           /* MIP start value */
//C     #define GRB_DBL_ATTR_PSTART         "PStart"          /* LP primal solution warm start */
//C     #define GRB_INT_ATTR_BRANCHPRIORITY "BranchPriority"  /* MIP branch priority */
//C     #define GRB_STR_ATTR_VARNAME        "VarName"         /* Variable name */
//C     #define GRB_INT_ATTR_PWLOBJCVX      "PWLObjCvx"       /* Convexity of variable PWL obj */
//C     #define GRB_DBL_ATTR_VARHINTVAL     "VarHintVal"
//C     #define GRB_INT_ATTR_VARHINTPRI     "VarHintPri"

/* Constraint attributes */
//C     #define GRB_DBL_ATTR_RHS        "RHS"        /* RHS */
//C     #define GRB_DBL_ATTR_DSTART     "DStart"     /* LP dual solution warm start */
//C     #define GRB_CHAR_ATTR_SENSE     "Sense"      /* Sense ('<', '>', or '=') */
//C     #define GRB_STR_ATTR_CONSTRNAME "ConstrName" /* Constraint name */
//C     #define GRB_INT_ATTR_LAZY       "Lazy"       /* Lazy constraint? */

/* Quadratic constraint attributes */
//C     #define GRB_DBL_ATTR_QCRHS    "QCRHS"   /* QC RHS */
//C     #define GRB_CHAR_ATTR_QCSENSE "QCSense" /* QC sense ('<', '>', or '=') */
//C     #define GRB_STR_ATTR_QCNAME   "QCName"  /* QC name */

/* Model statistics */
//C     #define GRB_DBL_ATTR_MAX_COEFF     "MaxCoeff"    /* Max (abs) nz coeff in A */
//C     #define GRB_DBL_ATTR_MIN_COEFF     "MinCoeff"    /* Min (abs) nz coeff in A */
//C     #define GRB_DBL_ATTR_MAX_BOUND     "MaxBound"    /* Max (abs) finite var bd */
//C     #define GRB_DBL_ATTR_MIN_BOUND     "MinBound"    /* Min (abs) var bd */
//C     #define GRB_DBL_ATTR_MAX_OBJ_COEFF "MaxObjCoeff" /* Max (abs) obj coeff */
//C     #define GRB_DBL_ATTR_MIN_OBJ_COEFF "MinObjCoeff" /* Min (abs) obj coeff */
//C     #define GRB_DBL_ATTR_MAX_RHS       "MaxRHS"      /* Max (abs) rhs coeff */
//C     #define GRB_DBL_ATTR_MIN_RHS       "MinRHS"      /* Min (abs) rhs coeff */

/* Model solution attributes */
//C     #define GRB_DBL_ATTR_RUNTIME       "Runtime"     /* Run time for optimization */
//C     #define GRB_INT_ATTR_STATUS        "Status"      /* Optimization status */
//C     #define GRB_DBL_ATTR_OBJVAL        "ObjVal"      /* Solution objective */
//C     #define GRB_DBL_ATTR_OBJBOUND      "ObjBound"    /* Best bound on solution */
//C     #define GRB_DBL_ATTR_OBJBOUNDC     "ObjBoundC"   /* Continuous bound */
//C     #define GRB_DBL_ATTR_MIPGAP        "MIPGap"      /* MIP optimality gap */
//C     #define GRB_INT_ATTR_SOLCOUNT      "SolCount"    /* # of solutions found */
//C     #define GRB_DBL_ATTR_ITERCOUNT     "IterCount"   /* Iters performed (simplex) */
//C     #define GRB_INT_ATTR_BARITERCOUNT  "BarIterCount" /* Iters performed (barrier) */
//C     #define GRB_DBL_ATTR_NODECOUNT     "NodeCount"    /* Nodes explored (B&C) */
//C     #define GRB_DBL_ATTR_OPENNODECOUNT "OpenNodeCount" /* Unexplored nodes (B&C) */
//C     #define GRB_INT_ATTR_HASDUALNORM   "HasDualNorm"  
/* 0, no basis,
                                                     1, has basis, so can be computed
                                                     2, available */

/* Variable attributes related to the current solution */
//C     #define GRB_DBL_ATTR_X         "X"         /* Solution value */
//C     #define GRB_DBL_ATTR_Xn        "Xn"        /* Alternate MIP solution */
//C     #define GRB_DBL_ATTR_BARX      "BarX"      /* Best barrier iterate */
//C     #define GRB_DBL_ATTR_RC        "RC"        /* Reduced costs */
//C     #define GRB_DBL_ATTR_VDUALNORM "VDualNorm" /* Dual norm square */
//C     #define GRB_INT_ATTR_VBASIS    "VBasis"    /* Variable basis status */

/* Constraint attributes related to the current solution */
//C     #define GRB_DBL_ATTR_PI        "Pi"        /* Dual value */
//C     #define GRB_DBL_ATTR_QCPI      "QCPi"      /* Dual value for QC */
//C     #define GRB_DBL_ATTR_SLACK     "Slack"     /* Constraint slack */
//C     #define GRB_DBL_ATTR_QCSLACK   "QCSlack"   /* QC Constraint slack */
//C     #define GRB_DBL_ATTR_CDUALNORM "CDualNorm" /* Dual norm square */
//C     #define GRB_INT_ATTR_CBASIS    "CBasis"    /* Constraint basis status */

/* Solution quality attributes */
//C     #define GRB_DBL_ATTR_BOUND_VIO              "BoundVio"
//C     #define GRB_DBL_ATTR_BOUND_SVIO             "BoundSVio"
//C     #define GRB_INT_ATTR_BOUND_VIO_INDEX        "BoundVioIndex"
//C     #define GRB_INT_ATTR_BOUND_SVIO_INDEX       "BoundSVioIndex"
//C     #define GRB_DBL_ATTR_BOUND_VIO_SUM          "BoundVioSum"
//C     #define GRB_DBL_ATTR_BOUND_SVIO_SUM         "BoundSVioSum"
//C     #define GRB_DBL_ATTR_CONSTR_VIO             "ConstrVio"
//C     #define GRB_DBL_ATTR_CONSTR_SVIO            "ConstrSVio"
//C     #define GRB_INT_ATTR_CONSTR_VIO_INDEX       "ConstrVioIndex"
//C     #define GRB_INT_ATTR_CONSTR_SVIO_INDEX      "ConstrSVioIndex"
//C     #define GRB_DBL_ATTR_CONSTR_VIO_SUM         "ConstrVioSum"
//C     #define GRB_DBL_ATTR_CONSTR_SVIO_SUM        "ConstrSVioSum"
//C     #define GRB_DBL_ATTR_CONSTR_RESIDUAL        "ConstrResidual"
//C     #define GRB_DBL_ATTR_CONSTR_SRESIDUAL       "ConstrSResidual"
//C     #define GRB_INT_ATTR_CONSTR_RESIDUAL_INDEX  "ConstrResidualIndex"
//C     #define GRB_INT_ATTR_CONSTR_SRESIDUAL_INDEX "ConstrSResidualIndex"
//C     #define GRB_DBL_ATTR_CONSTR_RESIDUAL_SUM    "ConstrResidualSum"
//C     #define GRB_DBL_ATTR_CONSTR_SRESIDUAL_SUM   "ConstrSResidualSum"
//C     #define GRB_DBL_ATTR_DUAL_VIO               "DualVio"
//C     #define GRB_DBL_ATTR_DUAL_SVIO              "DualSVio"
//C     #define GRB_INT_ATTR_DUAL_VIO_INDEX         "DualVioIndex"
//C     #define GRB_INT_ATTR_DUAL_SVIO_INDEX        "DualSVioIndex"
//C     #define GRB_DBL_ATTR_DUAL_VIO_SUM           "DualVioSum"
//C     #define GRB_DBL_ATTR_DUAL_SVIO_SUM          "DualSVioSum"
//C     #define GRB_DBL_ATTR_DUAL_RESIDUAL          "DualResidual"
//C     #define GRB_DBL_ATTR_DUAL_SRESIDUAL         "DualSResidual"
//C     #define GRB_INT_ATTR_DUAL_RESIDUAL_INDEX    "DualResidualIndex"
//C     #define GRB_INT_ATTR_DUAL_SRESIDUAL_INDEX   "DualSResidualIndex"
//C     #define GRB_DBL_ATTR_DUAL_RESIDUAL_SUM      "DualResidualSum"
//C     #define GRB_DBL_ATTR_DUAL_SRESIDUAL_SUM     "DualSResidualSum"
//C     #define GRB_DBL_ATTR_INT_VIO                "IntVio"
//C     #define GRB_INT_ATTR_INT_VIO_INDEX          "IntVioIndex"
//C     #define GRB_DBL_ATTR_INT_VIO_SUM            "IntVioSum"
//C     #define GRB_DBL_ATTR_COMPL_VIO              "ComplVio"
//C     #define GRB_INT_ATTR_COMPL_VIO_INDEX        "ComplVioIndex"
//C     #define GRB_DBL_ATTR_COMPL_VIO_SUM          "ComplVioSum"
//C     #define GRB_DBL_ATTR_KAPPA                  "Kappa"
//C     #define GRB_DBL_ATTR_KAPPA_EXACT            "KappaExact"
//C     #define GRB_DBL_ATTR_N2KAPPA                "N2Kappa"

/* LP sensitivity analysis */
//C     #define GRB_DBL_ATTR_SA_OBJLOW "SAObjLow"
//C     #define GRB_DBL_ATTR_SA_OBJUP  "SAObjUp"
//C     #define GRB_DBL_ATTR_SA_LBLOW  "SALBLow"
//C     #define GRB_DBL_ATTR_SA_LBUP   "SALBUp"
//C     #define GRB_DBL_ATTR_SA_UBLOW  "SAUBLow"
//C     #define GRB_DBL_ATTR_SA_UBUP   "SAUBUp"
//C     #define GRB_DBL_ATTR_SA_RHSLOW "SARHSLow"
//C     #define GRB_DBL_ATTR_SA_RHSUP  "SARHSUp"

/* IIS */
//C     #define GRB_INT_ATTR_IIS_MINIMAL "IISMinimal" /* Boolean: Is IIS Minimal? */
//C     #define GRB_INT_ATTR_IIS_LB      "IISLB"      /* Boolean: Is var LB in IIS? */
//C     #define GRB_INT_ATTR_IIS_UB      "IISUB"      /* Boolean: Is var UB in IIS? */
//C     #define GRB_INT_ATTR_IIS_CONSTR  "IISConstr"  /* Boolean: Is constr in IIS? */
//C     #define GRB_INT_ATTR_IIS_SOS     "IISSOS"     /* Boolean: Is SOS in IIS? */
//C     #define GRB_INT_ATTR_IIS_QCONSTR "IISQConstr" /* Boolean: Is QConstr in IIS? */

/* Tuning */
//C     #define GRB_INT_ATTR_TUNE_RESULTCOUNT "TuneResultCount"

/* advanced simplex features */
//C     #define GRB_DBL_ATTR_FARKASDUAL  "FarkasDual"
//C     #define GRB_DBL_ATTR_FARKASPROOF "FarkasProof"
//C     #define GRB_DBL_ATTR_UNBDRAY     "UnbdRay"
//C     #define GRB_INT_ATTR_INFEASVAR   "InfeasVar"
//C     #define GRB_INT_ATTR_UNBDVAR     "UnbdVar"

/* Presolve attribute */
//C     #define GRB_INT_ATTR_VARPRESTAT "VarPreStat"
//C     #define GRB_DBL_ATTR_PREFIXVAL  "PreFixVal"
