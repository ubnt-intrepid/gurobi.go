// vim: set ft=d ts=2 sw=2 et :
// dmd -c gurobi.d
module api_c;

extern (C) {
  struct _GRBmodel;
  struct _GRBenv;
  struct _GRBsvec
  {
    int len;
    int *ind;
    double *val;
  }
}

alias _GRBmodel GRBmodel;
alias _GRBenv   GRBenv;
alias _GRBsvec  GRBsvec;

// Version numbers
const GRB_VERSION_MAJOR     = 6;
const GRB_VERSION_MINOR     = 5;
const GRB_VERSION_TECHNICAL = 0;

// Default and max priority for Compute Server jobs
const DEFAULT_CS_PRIORITY = 0;
const MAX_CS_PRIORITY     = 100;

// Default port number for Compute Server
const DEFAULT_CS_PORT = 61000;

// Constraint senses
const GRB_LESS_EQUAL    = '<';
const GRB_GREATER_EQUAL = '>';
const GRB_EQUAL         = '=';

// Variable types
const GRB_CONTINUOUS = 'C';
const GRB_BINARY     = 'B';
const GRB_INTEGER    = 'I';
const GRB_SEMICONT   = 'S';
const GRB_SEMIINT    = 'N';

// Objective sense
const GRB_MINIMIZE = 1;
const GRB_MAXIMIZE = -1;

// SOS types
const GRB_SOS_TYPE1 = 1;
const GRB_SOS_TYPE2 = 2;

// Numeric constants
const GRB_INFINITY  = 1e100;
const GRB_UNDEFINED = 1e101;
const GRB_MAXINT    = 2000000000;

// Limits
const GRB_MAX_NAMELEN    = 255;
const GRB_MAX_STRLEN     = 512;
const GRB_MAX_CONCURRENT = 64;

const GRB_FEASRELAX_LINEAR      = 0;
const GRB_FEASRELAX_QUADRATIC   = 1;
const GRB_FEASRELAX_CARDINALITY = 2;

// Model status codes (after call to GRBoptimize())
const GRB_LOADED          = 1;
const GRB_OPTIMAL         = 2;
const GRB_INFEASIBLE      = 3;
const GRB_INF_OR_UNBD     = 4;
const GRB_UNBOUNDED       = 5;
const GRB_CUTOFF          = 6;
const GRB_ITERATION_LIMIT = 7;
const GRB_NODE_LIMIT      = 8;
const GRB_TIME_LIMIT      = 9;
const GRB_SOLUTION_LIMIT  = 10;
const GRB_INTERRUPTED     = 11;
const GRB_NUMERIC         = 12;
const GRB_SUBOPTIMAL      = 13;
const GRB_INPROGRESS      = 14;

// Basis status info
const GRB_BASIC = 0;
const GRB_NONBASIC_LOWER = -1;
const GRB_NONBASIC_UPPER = -2;
const GRB_SUPERBASIC = -3;

// All *CUTS parameters
const GRB_CUTS_AUTO           = -1;
const GRB_CUTS_OFF            = 0;
const GRB_CUTS_CONSERVATIVE   = 1;
const GRB_CUTS_AGGRESSIVE     = 2;
const GRB_CUTS_VERYAGGRESSIVE = 3;

const GRB_PRESOLVE_AUTO         = -1;
const GRB_PRESOLVE_OFF          = 0;
const GRB_PRESOLVE_CONSERVATIVE = 1;
const GRB_PRESOLVE_AGGRESSIVE   = 2;

const GRB_METHOD_AUTO                     = -1;
const GRB_METHOD_PRIMAL                   = 0;
const GRB_METHOD_DUAL                     = 1;
const GRB_METHOD_BARRIER                  = 2;
const GRB_METHOD_CONCURRENT               = 3;
const GRB_METHOD_DETERMINISTIC_CONCURRENT = 4;

const GRB_BARHOMOGENEOUS_AUTO = -1;
const GRB_BARHOMOGENEOUS_OFF  = 0;
const GRB_BARHOMOGENEOUS_ON   = 1;

const GRB_MIPFOCUS_BALANCED    = 0;
const GRB_MIPFOCUS_FEASIBILITY = 1;
const GRB_MIPFOCUS_OPTIMALITY  = 2;
const GRB_MIPFOCUS_BESTBOUND   = 3;

const GRB_BARORDER_AUTOMATIC        = -1;
const GRB_BARORDER_AMD              = 0;
const GRB_BARORDER_NESTEDDISSECTION = 1;

const GRB_SIMPLEXPRICING_AUTO           = -1;
const GRB_SIMPLEXPRICING_PARTIAL        = 0;
const GRB_SIMPLEXPRICING_STEEPEST_EDGE  = 1;
const GRB_SIMPLEXPRICING_DEVEX          = 2;
const GRB_SIMPLEXPRICING_STEEPEST_QUICK = 3;

const GRB_VARBRANCH_AUTO           = -1;
const GRB_VARBRANCH_PSEUDO_REDUCED = 0;
const GRB_VARBRANCH_PSEUDO_SHADOW  = 1;
const GRB_VARBRANCH_MAX_INFEAS     = 2;
const GRB_VARBRANCH_STRONG         = 3;

// Error codes
const GRB_ERROR_OUT_OF_MEMORY            = 10001;
const GRB_ERROR_NULL_ARGUMENT            = 10002;
const GRB_ERROR_INVALID_ARGUMENT         = 10003;
const GRB_ERROR_UNKNOWN_ATTRIBUTE        = 10004;
const GRB_ERROR_DATA_NOT_AVAILABLE       = 10005;
const GRB_ERROR_INDEX_OUT_OF_RANGE       = 10006;
const GRB_ERROR_UNKNOWN_PARAMETER        = 10007;
const GRB_ERROR_VALUE_OUT_OF_RANGE       = 10008;
const GRB_ERROR_NO_LICENSE               = 10009;
const GRB_ERROR_SIZE_LIMIT_EXCEEDED      = 10010;
const GRB_ERROR_CALLBACK                 = 10011;
const GRB_ERROR_FILE_READ                = 10012;
const GRB_ERROR_FILE_WRITE               = 10013;
const GRB_ERROR_NUMERIC                  = 10014;
const GRB_ERROR_IIS_NOT_INFEASIBLE       = 10015;
const GRB_ERROR_NOT_FOR_MIP              = 10016;
const GRB_ERROR_OPTIMIZATION_IN_PROGRESS = 10017;
const GRB_ERROR_DUPLICATES               = 10018;
const GRB_ERROR_NODEFILE                 = 10019;
const GRB_ERROR_Q_NOT_PSD                = 10020;
const GRB_ERROR_QCP_EQUALITY_CONSTRAINT  = 10021;
const GRB_ERROR_NETWORK                  = 10022;
const GRB_ERROR_JOB_REJECTED             = 10023;
const GRB_ERROR_NOT_SUPPORTED            = 10024;
const GRB_ERROR_EXCEED_2B_NONZEROS       = 10025;
const GRB_ERROR_INVALID_PIECEWISE_OBJ    = 10026;
const GRB_ERROR_UPDATEMODE_CHANGE        = 10027;

// For callback
const GRB_CB_POLLING  = 0;
const GRB_CB_PRESOLVE = 1;
const GRB_CB_SIMPLEX  = 2;
const GRB_CB_MIP      = 3;
const GRB_CB_MIPSOL   = 4;
const GRB_CB_MIPNODE  = 5;
const GRB_CB_MESSAGE  = 6;
const GRB_CB_BARRIER  = 7;

// Supported names for callback
const GRB_CB_PRE_COLDEL      = 1000;
const GRB_CB_PRE_ROWDEL      = 1001;
const GRB_CB_PRE_SENCHG      = 1002;
const GRB_CB_PRE_BNDCHG      = 1003;
const GRB_CB_PRE_COECHG      = 1004;
const GRB_CB_SPX_ITRCNT      = 2000;
const GRB_CB_SPX_OBJVAL      = 2001;
const GRB_CB_SPX_PRIMINF     = 2002;
const GRB_CB_SPX_DUALINF     = 2003;
const GRB_CB_SPX_ISPERT      = 2004;
const GRB_CB_MIP_OBJBST      = 3000;
const GRB_CB_MIP_OBJBND      = 3001;
const GRB_CB_MIP_NODCNT      = 3002;
const GRB_CB_MIP_SOLCNT      = 3003;
const GRB_CB_MIP_CUTCNT      = 3004;
const GRB_CB_MIP_NODLFT      = 3005;
const GRB_CB_MIP_ITRCNT      = 3006;
const GRB_CB_MIP_OBJBNDC     = 3007;
const GRB_CB_MIPSOL_SOL      = 4001;
const GRB_CB_MIPSOL_OBJ      = 4002;
const GRB_CB_MIPSOL_OBJBST   = 4003;
const GRB_CB_MIPSOL_OBJBND   = 4004;
const GRB_CB_MIPSOL_NODCNT   = 4005;
const GRB_CB_MIPSOL_SOLCNT   = 4006;
const GRB_CB_MIPSOL_OBJBNDC  = 4007;
const GRB_CB_MIPNODE_STATUS  = 5001;
const GRB_CB_MIPNODE_REL     = 5002;
const GRB_CB_MIPNODE_OBJBST  = 5003;
const GRB_CB_MIPNODE_OBJBND  = 5004;
const GRB_CB_MIPNODE_NODCNT  = 5005;
const GRB_CB_MIPNODE_SOLCNT  = 5006;
const GRB_CB_MIPNODE_BRVAR   = 5007;
const GRB_CB_MIPNODE_OBJBNDC = 5008;
const GRB_CB_MSG_STRING      = 6001;
const GRB_CB_RUNTIME         = 6002;
const GRB_CB_BARRIER_ITRCNT  = 7001;
const GRB_CB_BARRIER_PRIMOBJ = 7002;
const GRB_CB_BARRIER_DUALOBJ = 7003;
const GRB_CB_BARRIER_PRIMINF = 7004;
const GRB_CB_BARRIER_DUALINF = 7005;
const GRB_CB_BARRIER_COMPL   = 7006;

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
const GRB_INT_ATTR_MODELSENSE = "ModelSense";    /* 1=min, -1=max */
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
const GRB_INT_ATTR_STATUS = "Status";      /* Optimization status */
const GRB_DBL_ATTR_OBJVAL = "ObjVal";      /* Solution objective */
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
const GRB_DBL_ATTR_X = "X";         /* Solution value */
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

//C     #define GRB_INT_PAR_BARITERLIMIT   "BarIterLimit"
//C     #define GRB_DBL_PAR_CUTOFF         "Cutoff"
//C     #define GRB_DBL_PAR_ITERATIONLIMIT "IterationLimit"
//C     #define GRB_DBL_PAR_NODELIMIT      "NodeLimit"
//C     #define GRB_INT_PAR_SOLUTIONLIMIT  "SolutionLimit"
//C     #define GRB_DBL_PAR_TIMELIMIT      "TimeLimit"

/* Tolerances */

//C     #define GRB_DBL_PAR_FEASIBILITYTOL "FeasibilityTol"
//C     #define GRB_DBL_PAR_INTFEASTOL     "IntFeasTol"
//C     #define GRB_DBL_PAR_MARKOWITZTOL   "MarkowitzTol"
//C     #define GRB_DBL_PAR_MIPGAP         "MIPGap"
//C     #define GRB_DBL_PAR_MIPGAPABS      "MIPGapAbs"
//C     #define GRB_DBL_PAR_OPTIMALITYTOL  "OptimalityTol"
//C     #define GRB_DBL_PAR_PSDTOL         "PSDTol"

/* Simplex */

//C     #define GRB_INT_PAR_METHOD         "Method"
//C     #define GRB_DBL_PAR_PERTURBVALUE   "PerturbValue"
//C     #define GRB_DBL_PAR_OBJSCALE       "ObjScale"
//C     #define GRB_INT_PAR_SCALEFLAG      "ScaleFlag"
//C     #define GRB_INT_PAR_SIMPLEXPRICING "SimplexPricing"
//C     #define GRB_INT_PAR_QUAD           "Quad"
//C     #define GRB_INT_PAR_NORMADJUST     "NormAdjust"
//C     #define GRB_INT_PAR_SIFTING        "Sifting"
//C     #define GRB_INT_PAR_SIFTMETHOD     "SiftMethod"

/* Barrier */

//C     #define GRB_DBL_PAR_BARCONVTOL     "BarConvTol"
//C     #define GRB_INT_PAR_BARCORRECTORS  "BarCorrectors"
//C     #define GRB_INT_PAR_BARHOMOGENEOUS "BarHomogeneous"
//C     #define GRB_INT_PAR_BARORDER       "BarOrder"
//C     #define GRB_DBL_PAR_BARQCPCONVTOL  "BarQCPConvTol"
//C     #define GRB_INT_PAR_CROSSOVER      "Crossover"
//C     #define GRB_INT_PAR_CROSSOVERBASIS "CrossoverBasis"

/* MIP */

//C     #define GRB_INT_PAR_BRANCHDIR         "BranchDir"
//C     #define GRB_INT_PAR_DISCONNECTED      "Disconnected"
//C     #define GRB_DBL_PAR_HEURISTICS        "Heuristics"
//C     #define GRB_DBL_PAR_IMPROVESTARTGAP   "ImproveStartGap"
//C     #define GRB_DBL_PAR_IMPROVESTARTTIME  "ImproveStartTime"
//C     #define GRB_DBL_PAR_IMPROVESTARTNODES "ImproveStartNodes"
//C     #define GRB_INT_PAR_MINRELNODES       "MinRelNodes"
//C     #define GRB_INT_PAR_MIPFOCUS          "MIPFocus"
//C     #define GRB_STR_PAR_NODEFILEDIR       "NodefileDir"
//C     #define GRB_DBL_PAR_NODEFILESTART     "NodefileStart"
//C     #define GRB_INT_PAR_NODEMETHOD        "NodeMethod"
//C     #define GRB_INT_PAR_NORELHEURISTIC    "NoRelHeuristic"
//C     #define GRB_INT_PAR_PUMPPASSES        "PumpPasses"
//C     #define GRB_INT_PAR_RINS              "RINS"
//C     #define GRB_INT_PAR_SUBMIPNODES       "SubMIPNodes"
//C     #define GRB_INT_PAR_SYMMETRY          "Symmetry"
//C     #define GRB_INT_PAR_VARBRANCH         "VarBranch"
//C     #define GRB_INT_PAR_SOLUTIONNUMBER    "SolutionNumber"
//C     #define GRB_INT_PAR_ZEROOBJNODES      "ZeroObjNodes"

/* MIP cuts */

//C     #define GRB_INT_PAR_CUTS          "Cuts"

//C     #define GRB_INT_PAR_CLIQUECUTS    "CliqueCuts"
//C     #define GRB_INT_PAR_COVERCUTS     "CoverCuts"
//C     #define GRB_INT_PAR_FLOWCOVERCUTS "FlowCoverCuts"
//C     #define GRB_INT_PAR_FLOWPATHCUTS  "FlowPathCuts"
//C     #define GRB_INT_PAR_GUBCOVERCUTS  "GUBCoverCuts"
//C     #define GRB_INT_PAR_IMPLIEDCUTS   "ImpliedCuts"
//C     #define GRB_INT_PAR_MIPSEPCUTS    "MIPSepCuts"
//C     #define GRB_INT_PAR_MIRCUTS       "MIRCuts"
//C     #define GRB_INT_PAR_MODKCUTS      "ModKCuts"
//C     #define GRB_INT_PAR_ZEROHALFCUTS  "ZeroHalfCuts"
//C     #define GRB_INT_PAR_NETWORKCUTS   "NetworkCuts"
//C     #define GRB_INT_PAR_SUBMIPCUTS    "SubMIPCuts"

//C     #define GRB_INT_PAR_CUTAGGPASSES  "CutAggPasses"
//C     #define GRB_INT_PAR_CUTPASSES     "CutPasses"
//C     #define GRB_INT_PAR_GOMORYPASSES  "GomoryPasses"

/* Distributed algorithms */
//C     #define GRB_STR_PAR_WORKERPOOL      "WorkerPool"
//C     #define GRB_STR_PAR_WORKERPASSWORD  "WorkerPassword"
//C     #define GRB_INT_PAR_WORKERPORT      "WorkerPort"

/* Other */
//C     #define GRB_INT_PAR_AGGREGATE         "Aggregate"
//C     #define GRB_INT_PAR_AGGFILL           "AggFill"
//C     #define GRB_INT_PAR_CONCURRENTMIP     "ConcurrentMIP"
//C     #define GRB_INT_PAR_CONCURRENTJOBS    "ConcurrentJobs"
//C     #define GRB_INT_PAR_DISPLAYINTERVAL   "DisplayInterval"
//C     #define GRB_INT_PAR_DISTRIBUTEDMIPJOBS "DistributedMIPJobs"
//C     #define GRB_INT_PAR_DUALREDUCTIONS    "DualReductions"
//C     #define GRB_DBL_PAR_FEASRELAXBIGM     "FeasRelaxBigM"
//C     #define GRB_INT_PAR_IISMETHOD         "IISMethod"
//C     #define GRB_INT_PAR_INFUNBDINFO       "InfUnbdInfo"
//C     #define GRB_INT_PAR_LAZYCONSTRAINTS   "LazyConstraints"
//C     #define GRB_STR_PAR_LOGFILE           "LogFile"
//C     #define GRB_INT_PAR_LOGTOCONSOLE      "LogToConsole"
//C     #define GRB_INT_PAR_MIQCPMETHOD       "MIQCPMethod"
//C     #define GRB_INT_PAR_NUMERICFOCUS      "NumericFocus"
//C     #define GRB_INT_PAR_OUTPUTFLAG        "OutputFlag"
//C     #define GRB_INT_PAR_PRECRUSH          "PreCrush"
//C     #define GRB_INT_PAR_PREDEPROW         "PreDepRow"
//C     #define GRB_INT_PAR_PREDUAL           "PreDual"
//C     #define GRB_INT_PAR_PREPASSES         "PrePasses"
//C     #define GRB_INT_PAR_PREQLINEARIZE     "PreQLinearize"
//C     #define GRB_INT_PAR_PRESOLVE          "Presolve"
//C     #define GRB_DBL_PAR_PRESOS1BIGM       "PreSOS1BigM"
//C     #define GRB_DBL_PAR_PRESOS2BIGM       "PreSOS2BigM"
//C     #define GRB_INT_PAR_PRESPARSIFY       "PreSparsify"
//C     #define GRB_INT_PAR_PREMIQCPFORM      "PreMIQCPForm"
//C     #define GRB_INT_PAR_QCPDUAL           "QCPDual"
//C     #define GRB_INT_PAR_RECORD            "Record"
//C     #define GRB_STR_PAR_RESULTFILE        "ResultFile"
//C     #define GRB_INT_PAR_SEED              "Seed"
//C     #define GRB_INT_PAR_THREADS           "Threads"
//C     #define GRB_DBL_PAR_TUNETIMELIMIT     "TuneTimeLimit"
//C     #define GRB_INT_PAR_TUNERESULTS       "TuneResults"
//C     #define GRB_INT_PAR_TUNETRIALS        "TuneTrials"
//C     #define GRB_INT_PAR_TUNEOUTPUT        "TuneOutput"
//C     #define GRB_INT_PAR_TUNEJOBS          "TuneJobs"
//C     #define GRB_INT_PAR_UPDATEMODE        "UpdateMode"
//C     #define GRB_STR_PAR_DUMMY             "Dummy"


/* Query interface */
extern (Windows)
{
  int GRBgetattrinfo(GRBmodel *model, char *attrname, int *datatypeP, int *sizeP, int *settableP);
  int GRBisattravailable(GRBmodel *model, char *attrname);
  int GRBgetintattr(GRBmodel *model, char *attrname, int *valueP);
  int GRBsetintattr(GRBmodel *model, char *attrname, int newvalue);
  int GRBgetintattrelement(GRBmodel *model, char *attrname, int element, int *valueP);
  int GRBsetintattrelement(GRBmodel *model, char *attrname, int element, int newvalue);
  int GRBgetintattrarray(GRBmodel *model, char *attrname, int first, int len, int *values);
  int GRBsetintattrarray(GRBmodel *model, char *attrname, int first, int len, int *newvalues);
  int GRBgetintattrlist(GRBmodel *model, char *attrname, int len, int *ind, int *values);
  int GRBsetintattrlist(GRBmodel *model, char *attrname, int len, int *ind, int *newvalues);
  int GRBgetcharattrelement(GRBmodel *model, char *attrname, int element, char *valueP);
  int GRBsetcharattrelement(GRBmodel *model, char *attrname, int element, char newvalue);
  int GRBgetcharattrarray(GRBmodel *model, char *attrname, int first, int len, char *values);
  int GRBsetcharattrarray(GRBmodel *model, char *attrname, int first, int len, char *newvalues);
  int GRBgetcharattrlist(GRBmodel *model, char *attrname, int len, int *ind, char *values);
  int GRBsetcharattrlist(GRBmodel *model, char *attrname, int len, int *ind, char *newvalues);
  int GRBgetdblattr(GRBmodel *model, char *attrname, double *valueP);
  int GRBsetdblattr(GRBmodel *model, char *attrname, double newvalue);
  int GRBgetdblattrelement(GRBmodel *model, char *attrname, int element, double *valueP);
  int GRBsetdblattrelement(GRBmodel *model, char *attrname, int element, double newvalue);
  int GRBgetdblattrarray(GRBmodel *model, char *attrname, int first, int len, double *values);
  int GRBsetdblattrarray(GRBmodel *model, char *attrname, int first, int len, double *newvalues);
  int GRBgetdblattrlist(GRBmodel *model, char *attrname, int len, int *ind, double *values);
  int GRBsetdblattrlist(GRBmodel *model, char *attrname, int len, int *ind, double *newvalues);
  int GRBgetstrattr(GRBmodel *model, char *attrname, char **valueP);
  int GRBsetstrattr(GRBmodel *model, char *attrname, char *newvalue);
  int GRBgetstrattrelement(GRBmodel *model, char *attrname, int element, char **valueP);
  int GRBsetstrattrelement(GRBmodel *model, char *attrname, int element, char *newvalue);
  int GRBgetstrattrarray(GRBmodel *model, char *attrname, int first, int len, char **values);
  int GRBsetstrattrarray(GRBmodel *model, char *attrname, int first, int len, char **newvalues);
  int GRBgetstrattrlist(GRBmodel *model, char *attrname, int len, int *ind, char **values);
  int GRBsetstrattrlist(GRBmodel *model, char *attrname, int len, int *ind, char **newvalues);
  int GRBsetcallbackfunc(GRBmodel *model, int function(GRBmodel *model, void *cbdata, int where, void *usrdata)cb, void *usrdata);
  int GRBgetcallbackfunc(GRBmodel *model, int function(GRBmodel *model, void *cbdata, int where, void *usrdata)*cbP);
  int GRBsetlogcallbackfunc(GRBmodel *model, int  function(char *msg)cb);
  int GRBsetlogcallbackfuncenv(GRBenv *env, int  function(char *msg)cb);
  int GRBcbget(void *cbdata, int where, int what, void *resultP);
  int GRBcbsetparam(void *cbdata, char *paramname, char *newvalue);
  int GRBcbsolution(void *cbdata, double *solution);
  int GRBcbcut(void *cbdata, int cutlen, int *cutind, double *cutval, char cutsense, double cutrhs);
  int GRBcblazy(void *cbdata, int lazylen, int *lazyind, double *lazyval, char lazysense, double lazyrhs);
  int GRBgetcoeff(GRBmodel *model, int constr, int var, double *valP);
  int GRBgetconstrs(GRBmodel *model, int *numnzP, int *cbeg, int *cind, double *cval, int start, int len);
  int GRBgetvars(GRBmodel *model, int *numnzP, int *vbeg, int *vind, double *vval, int start, int len);
  int GRBgetsos(GRBmodel *model, int *nummembersP, int *sostype, int *beg, int *ind, double *weight, int start, int len);
  int GRBgetq(GRBmodel *model, int *numqnzP, int *qrow, int *qcol, double *qval);
  int GRBgetqconstr(GRBmodel *model, int qconstr, int *numlnzP, int *lind, double *lval, int *numqnzP, int *qrow, int *qcol, double *qval);
  int GRBgetvarbyname(GRBmodel *model, char *name, int *indexP);
  int GRBgetconstrbyname(GRBmodel *model, char *name, int *indexP);
  int GRBgetpwlobj(GRBmodel *model, int var, int *pointsP, double *x, double *y);
  int GRBoptimize(GRBmodel *model);
  int GRBoptimizeasync(GRBmodel *model);
  int GRBfeasrelax(GRBmodel *model, int relaxobjtype, int minrelax, double *lbpen, double *ubpen, double *rhspen, double *feasobjP);
  int GRBreadmodel(GRBenv *env, char *filename, GRBmodel **modelP);
  int GRBread(GRBmodel *model, char *filename);
  int GRBwrite(GRBmodel *model, char *filename);
  int GRBnewmodel(GRBenv *env, GRBmodel **modelP, char *Pname, int numvars, double *obj, double *lb, double *ub, char *vtype, char **varnames);
  int GRBloadmodel(GRBenv *env, GRBmodel **modelP, char *Pname, int numvars, int numconstrs, int objsense, double objcon, double *obj, char *sense, double *rhs, int *vbeg, int *vlen, int *vind, double *vval, double *lb, double *ub, char *vtype, char **varnames, char **constrnames);
  int GRBaddvar(GRBmodel *model, int numnz, int *vind, double *vval, double obj, double lb, double ub, char vtype, char *varname);
  int GRBaddvars(GRBmodel *model, int numvars, int numnz, int *vbeg, int *vind, double *vval, double *obj, double *lb, double *ub, char *vtype, char **varnames);
  int GRBaddconstr(GRBmodel *model, int numnz, int *cind, double *cval, char sense, double rhs, char *constrname);
  int GRBaddconstrs(GRBmodel *model, int numconstrs, int numnz, int *cbeg, int *cind, double *cval, char *sense, double *rhs, char **constrnames);
  int GRBaddrangeconstr(GRBmodel *model, int numnz, int *cind, double *cval, double lower, double upper, char *constrname);
  int GRBaddrangeconstrs(GRBmodel *model, int numconstrs, int numnz, int *cbeg, int *cind, double *cval, double *lower, double *upper, char **constrnames);
  int GRBaddsos(GRBmodel *model, int numsos, int nummembers, int *types, int *beg, int *ind, double *weight);
  int GRBaddqconstr(GRBmodel *model, int numlnz, int *lind, double *lval, int numqnz, int *qrow, int *qcol, double *qval, char sense, double rhs, char *QCname);
  int GRBaddcone(GRBmodel *model, int nummembers, int *members);
  int GRBaddqpterms(GRBmodel *model, int numqnz, int *qrow, int *qcol, double *qval);
  int GRBdelvars(GRBmodel *model, int len, int *ind);
  int GRBdelconstrs(GRBmodel *model, int len, int *ind);
  int GRBdelsos(GRBmodel *model, int len, int *ind);
  int GRBdelqconstrs(GRBmodel *model, int len, int *ind);
  int GRBdelq(GRBmodel *model);
  int GRBchgcoeffs(GRBmodel *model, int cnt, int *cind, int *vind, double *val);
  int GRBsetpwlobj(GRBmodel *model, int var, int points, double *x, double *y);
  int GRBupdatemodel(GRBmodel *model);
  int GRBresetmodel(GRBmodel *model);
  int GRBfreemodel(GRBmodel *model);
  int GRBcomputeIIS(GRBmodel *model);
  int GRBFSolve(GRBmodel *model, GRBsvec *b, GRBsvec *x);
  int GRBBinvColj(GRBmodel *model, int j, GRBsvec *x);
  int GRBBinvj(GRBmodel *model, int j, GRBsvec *x);
  int GRBBSolve(GRBmodel *model, GRBsvec *b, GRBsvec *x);
  int GRBBinvi(GRBmodel *model, int i, GRBsvec *x);
  int GRBBinvRowi(GRBmodel *model, int i, GRBsvec *x);
  int GRBgetBasisHead(GRBmodel *model, int *bhead);
  int GRBcheckmodel(GRBmodel *model);
  int GRBreplay(char *filename);
  int GRBgetintparam(GRBenv *env, char *paramname, int *valueP);
  int GRBgetdblparam(GRBenv *env, char *paramname, double *valueP);
  int GRBgetstrparam(GRBenv *env, char *paramname, char *valueP);
  int GRBgetintparaminfo(GRBenv *env, char *paramname, int *valueP, int *minP, int *maxP, int *defP);
  int GRBgetdblparaminfo(GRBenv *env, char *paramname, double *valueP, double *minP, double *maxP, double *defP);
  int GRBgetstrparaminfo(GRBenv *env, char *paramname, char *valueP, char *defP);
  int GRBsetparam(GRBenv *env, char *paramname, char *value);
  int GRBsetintparam(GRBenv *env, char *paramname, int value);
  int GRBsetdblparam(GRBenv *env, char *paramname, double value);
  int GRBsetstrparam(GRBenv *env, char *paramname, char *value);
  int GRBgetparamtype(GRBenv *env, char *paramname);
  int GRBresetparams(GRBenv *env);
  int GRBcopyparams(GRBenv *dest, GRBenv *src);
  int GRBwriteparams(GRBenv *env, char *filename);
  int GRBreadparams(GRBenv *env, char *filename);
  int GRBgetnumparams(GRBenv *env);
  int GRBgetparamname(GRBenv *env, int i, char **paramnameP);
  int GRBgetnumattributes(GRBmodel *model);
  int GRBgetattrname(GRBmodel *model, int i, char **attrnameP);
  int GRBloadenv(GRBenv **envP, char *logfilename);
  int GRBloadenvadv(GRBenv **envP, char *logfilename, int function(GRBmodel *model, void *cbdata, int where, void *usrdata)cb, void *usrdata);
  int GRBloadclientenv(GRBenv **envP, char *logfilename, char *computeservers, int port, char *password, int priority, double timeout);
  int GRBloadclientenvadv(GRBenv **envP, char *logfilename, char *computeservers, int port, char *password, int priority, double timeout, int function(GRBmodel *model, void *cbdata, int where, void *usrdata)cb, void *usrdata);
  int GRBlisttokens();
  int GRBlistclients(char *computeServer, int port);
  int GRBchangeuserpassword(char *computeServer, int port, char *admin_password, char *new_user_password);
  int GRBchangeadminpassword(char *computeServer, int port, char *admin_password, char *new_admin_password);
  int GRBchangejoblimit(char *computeServer, int port, int newlimit, char *admin_password);
  int GRBkilljob(char *computeServer, int port, char *jobID, char *admin_password);
  int GRBtunemodel(GRBmodel *model);
  int GRBtunemodels(int nummodels, GRBmodel **models, GRBmodel *ignore, GRBmodel *hint);
  int GRBgettuneresult(GRBmodel *model, int i);
  int GRBgettunelog(GRBmodel *model, int i, char **logP);
  int GRBtunemodeladv(GRBmodel *model, GRBmodel *ignore, GRBmodel *hint);
  int GRBsync(GRBmodel *model);

  void  GRBsetsignal(GRBmodel *model);
  void  GRBterminate(GRBmodel *model);
  void  GRBclean2(int *lenP, int *ind, double *val);
  void  GRBclean3(int *lenP, int *ind0, int *ind1, double *val);
  void  GRBmsg(GRBenv *env, char *message);
  void  GRBdiscardconcurrentenvs(GRBmodel *model);
  void  GRBreleaselicense(GRBenv *env);
  void  GRBfreeenv(GRBenv *env);
  void  GRBversion(int *majorP, int *minorP, int *technicalP);

  char* GRBgeterrormsg(GRBenv *env);
  char* GRBgetmerrormsg(GRBmodel *model);
  char* GRBplatform();

  GRBmodel* GRBcopymodel(GRBmodel *model);
  GRBmodel* GRBfixedmodel(GRBmodel *model);
  GRBenv* GRBgetenv(GRBmodel *model);
  GRBenv* GRBgetconcurrentenv(GRBmodel *model, int num);

  // Undocumented routines
  int GRBgetcbwhatinfo(void *cbdata, int what, int *typeP, int *sizeP);
  int GRBconverttofixed(GRBmodel *model);
  int GRBstrongbranch(GRBmodel *model, int num, int *cand, double *downobjbd, double *upobjbd, int *statusP);
  GRBmodel* GRBrelaxmodel(GRBmodel *model);
  GRBmodel* GRBpresolvemodel(GRBmodel *model);
  GRBmodel* GRBiismodel(GRBmodel *model);
  GRBmodel* GRBfeasibility(GRBmodel *model);
  GRBmodel* GRBlinearizemodel(GRBmodel *model);

  // TODO: implement
  // #define MALLOCCB_ARGS size_t size, void *syscbusrdata
  // #define CALLOCCB_ARGS size_t nmemb, size_t size, void *syscbusrdata
  // #define REALLOCCB_ARGS void *ptr, size_t size, void *syscbusrdata
  // #define FREECB_ARGS void *ptr, void *syscbusrdata
  // #define THREADCREATECB_ARGS void **threadP, void (*start_routine)(void *), void *arg, void *syscbusrdata
  // #define THREADJOINCB_ARGS void *thread, void *syscbusrdata
  // int __stdcall
  // GRBloadenvsyscb(GRBenv **envP, const char *logfilename,
  //                 void * (__stdcall *malloccb)(MALLOCCB_ARGS),
  //                 void * (__stdcall *calloccb)(CALLOCCB_ARGS),
  //                 void * (__stdcall *realloccb)(REALLOCCB_ARGS),
  //                 void (__stdcall *freecb)(FREECB_ARGS),
  //                 int (__stdcall *threadcreatecb)(THREADCREATECB_ARGS),
  //                 void (__stdcall *threadjoincb)(THREADJOINCB_ARGS),
  //                 void *syscbusrdata);

  // TODO: implement size_t version of API
  // int __stdcall GRBXgetconstrs(GRBmodel *model, size_t *numnzP, size_t *cbeg, int *cind, double *cval, int start, int len);
  // int __stdcall GRBXgetvars(GRBmodel *model, size_t *numnzP, size_t *vbeg, int *vind, double *vval, int start, int len);
  // int __stdcall GRBXloadmodel(GRBenv *env, GRBmodel **modelP, const char *Pname, int numvars, int numconstrs, int objsense, double objcon, double *obj, char *sense, double *rhs, size_t *vbeg, int *vlen, int *vind, double *vval, double *lb, double *ub, char *vtype, char **varnames, char **constrnames);
  // int __stdcall GRBXaddvars(GRBmodel *model, int numvars, size_t numnz, size_t *vbeg, int *vind, double *vval, double *obj, double *lb, double *ub, char *vtype, char **varnames);
  // int __stdcall GRBXaddconstrs(GRBmodel *model, int numconstrs, size_t numnz, size_t *cbeg, int *cind, double *cval, char *sense, double *rhs, char **constrnames);
  // int __stdcall GRBXaddrangeconstrs(GRBmodel *model, int numconstrs, size_t numnz, size_t *cbeg, int *cind, double *cval, double *lower, double *upper, char **constrnames);
  // int __stdcall GRBXchgcoeffs(GRBmodel *model, size_t cnt, int *cind, int *vind, double *val);
}
