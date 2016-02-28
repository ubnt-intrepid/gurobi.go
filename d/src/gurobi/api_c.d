// vim: set ft=d ts=2 sw=2 et :
// dmd -c gurobi.d
module api_c;

public import errors;
private import std.typecons : Tuple;

extern (C)
{
  struct _GRBmodel;
  struct _GRBenv;
  struct _GRBsvec
  {
    int len;
    int* ind;
    double* val;
  }
}

alias GRBmodel = _GRBmodel;
alias GRBenv = _GRBenv;
alias GRBsvec = _GRBsvec;

// Default and max priority for Compute Server jobs
enum DEFAULT_CS_PRIORITY = 0;
enum MAX_CS_PRIORITY = 100;

// Default port number for Compute Server
enum DEFAULT_CS_PORT = 61000;

// Constraint senses
enum ConstrSense : char {
  LESS_EQUAL    = '<',
  GREATER_EQUAL = '>',
  EQUAL         = '=',
}

// Variable types
enum VarType : char {
  CONTINUOUS = 'C',
  BINARY     = 'B',
  INTEGER    = 'I',
  SEMICONT   = 'S',
  SEMIINT    = 'N',
}

// Objective sense
enum ModelSense : int {
  MINIMIZE = 1,
  MAXIMIZE = -1,
}

// SOS types
enum SOSType : int {
  GRB_SOS_TYPE1 = 1,
  GRB_SOS_TYPE2 = 2,
}

// Numeric enumants
enum GRB_INFINITY = 1e100;
enum GRB_UNDEFINED = 1e101;
enum GRB_MAXINT = 2000000000;

// Limits
enum GRB_MAX_NAMELEN = 255;
enum GRB_MAX_STRLEN = 512;
enum GRB_MAX_CONCURRENT = 64;

enum FeasRelaxType : int {
  LINEAR      = 0,
  QUADRATIC   = 1,
  CARDINALITY = 2,
}

// Model status codes (after call to GRBoptimize())
enum Status : int {
  LOADED          = 1,
  OPTIMAL         = 2,
  INFEASIBLE      = 3,
  INF_OR_UNBD     = 4,
  UNBOUNDED       = 5,
  CUTOFF          = 6,
  ITERATION_LIMIT = 7,
  NODE_LIMIT      = 8,
  TIME_LIMIT      = 9,
  SOLUTION_LIMIT  = 10,
  INTERRUPTED     = 11,
  NUMERIC         = 12,
  SUBOPTIMAL      = 13,
  INPROGRESS      = 14,
}

// Basis status info
enum BasisStatusInfo : int {
  BASIC          = 0,
  NONBASIC_LOWER = -1,
  NONBASIC_UPPER = -2,
  SUPERBASIC     = -3,
}

// All *CUTS parameters
enum GRB_CUTS_AUTO = -1;
enum GRB_CUTS_OFF = 0;
enum GRB_CUTS_CONSERVATIVE = 1;
enum GRB_CUTS_AGGRESSIVE = 2;
enum GRB_CUTS_VERYAGGRESSIVE = 3;

enum GRB_PRESOLVE_AUTO = -1;
enum GRB_PRESOLVE_OFF = 0;
enum GRB_PRESOLVE_CONSERVATIVE = 1;
enum GRB_PRESOLVE_AGGRESSIVE = 2;

enum GRB_METHOD_AUTO = -1;
enum GRB_METHOD_PRIMAL = 0;
enum GRB_METHOD_DUAL = 1;
enum GRB_METHOD_BARRIER = 2;
enum GRB_METHOD_CONCURRENT = 3;
enum GRB_METHOD_DETERMINISTIC_CONCURRENT = 4;

enum GRB_BARHOMOGENEOUS_AUTO = -1;
enum GRB_BARHOMOGENEOUS_OFF = 0;
enum GRB_BARHOMOGENEOUS_ON = 1;

enum MIPFocus : int {
  BALANCED    = 0,
  FEASIBILITY = 1,
  OPTIMALITY  = 2,
  BESTBOUND   = 3,
}

enum GRB_BARORDER_AUTOMATIC = -1;
enum GRB_BARORDER_AMD = 0;
enum GRB_BARORDER_NESTEDDISSECTION = 1;

enum SimplexPricing : int {
  AUTO           = -1,
  PARTIAL        = 0,
  STEEPEST_EDGE  = 1,
  DEVEX          = 2,
  STEEPEST_QUICK = 3,
}

enum VarBranch : int {
  AUTO           = -1,
  PSEUDO_REDUCED = 0,
  PSEUDO_SHADOW  = 1,
  MAX_INFEAS     = 2,
  STRONG         = 3,
}

// For callback
enum CallbackWhere : int {
  POLLING  = 0,
  PRESOLVE = 1,
  SIMPLEX  = 2,
  MIP      = 3,
  MIPSOL   = 4,
  MIPNODE  = 5,
  MESSAGE  = 6,
  BARRIER  = 7,
}

// Supported names for callback
enum CallbackWhat : int {
  PRE_COLDEL      = 1000,
  PRE_ROWDEL      = 1001,
  PRE_SENCHG      = 1002,
  PRE_BNDCHG      = 1003,
  PRE_COECHG      = 1004,
  SPX_ITRCNT      = 2000,
  SPX_OBJVAL      = 2001,
  SPX_PRIMINF     = 2002,
  SPX_DUALINF     = 2003,
  SPX_ISPERT      = 2004,
  MIP_OBJBST      = 3000,
  MIP_OBJBND      = 3001,
  MIP_NODCNT      = 3002,
  MIP_SOLCNT      = 3003,
  MIP_CUTCNT      = 3004,
  MIP_NODLFT      = 3005,
  MIP_ITRCNT      = 3006,
  MIP_OBJBNDC     = 3007,
  MIPSOL_SOL      = 4001,
  MIPSOL_OBJ      = 4002,
  MIPSOL_OBJBST   = 4003,
  MIPSOL_OBJBND   = 4004,
  MIPSOL_NODCNT   = 4005,
  MIPSOL_SOLCNT   = 4006,
  MIPSOL_OBJBNDC  = 4007,
  MIPNODE_STATUS  = 5001,
  MIPNODE_REL     = 5002,
  MIPNODE_OBJBST  = 5003,
  MIPNODE_OBJBND  = 5004,
  MIPNODE_NODCNT  = 5005,
  MIPNODE_SOLCNT  = 5006,
  MIPNODE_BRVAR   = 5007,
  MIPNODE_OBJBNDC = 5008,
  MSG_STRING      = 6001,
  RUNTIME         = 6002,
  BARRIER_ITRCNT  = 7001,
  BARRIER_PRIMOBJ = 7002,
  BARRIER_DUALOBJ = 7003,
  BARRIER_PRIMINF = 7004,
  BARRIER_DUALINF = 7005,
  BARRIER_COMPL   = 7006,
}

enum IntAttr : string {
  ModelSense = "ModelSense",
}

enum DoubleAttr : string {
  ObjVal = "ObjVal",
}

enum DoubleArrayAttr : Tuple!(string, string) {
  X = Tuple!(string, string)("X", "NumVars"),
}

// Model attributes
enum GRB_INT_ATTR_NUMCONSTRS = "NumConstrs"; // # of constraints
enum GRB_INT_ATTR_NUMVARS = "NumVars"; // # of vars
enum GRB_INT_ATTR_NUMSOS = "NumSOS"; // # of sos constraints
enum GRB_INT_ATTR_NUMQCONSTRS = "NumQConstrs"; // # of quadratic constraints
enum GRB_INT_ATTR_NUMNZS = "NumNZs"; // # of nz in A
enum GRB_DBL_ATTR_DNUMNZS = "DNumNZs"; // # of nz in A
enum GRB_INT_ATTR_NUMQNZS = "NumQNZs"; // # of nz in Q
enum GRB_INT_ATTR_NUMQCNZS = "NumQCNZs"; // # of nz in q constraints
enum GRB_INT_ATTR_NUMINTVARS = "NumIntVars"; // # of integer vars
enum GRB_INT_ATTR_NUMBINVARS = "NumBinVars"; // # of binary vars
enum GRB_INT_ATTR_NUMPWLOBJVARS = "NumPWLObjVars"; // # of variables with PWL obj.
enum GRB_STR_ATTR_MODELNAME = "ModelName"; // model name
enum GRB_INT_ATTR_MODELSENSE = "ModelSense"; // 1 = min, -1 = max
enum GRB_DBL_ATTR_OBJCON = "ObjCon"; // Objective constant
enum GRB_INT_ATTR_IS_MIP = "IsMIP"; // Is model a MIP?
enum GRB_INT_ATTR_IS_QP = "IsQP"; // Model has quadratic obj?
enum GRB_INT_ATTR_IS_QCP = "IsQCP"; // Model has quadratic constr?
enum GRB_STR_ATTR_SERVER = "Server"; // Name of compute server

// Variable attributes
enum GRB_DBL_ATTR_LB = "LB"; // Lower bound
enum GRB_DBL_ATTR_UB = "UB"; // Upper bound
enum GRB_DBL_ATTR_OBJ = "Obj"; // Objective coeff
enum GRB_CHAR_ATTR_VTYPE = "VType"; // Integrality type
enum GRB_DBL_ATTR_START = "Start"; // MIP start value
enum GRB_DBL_ATTR_PSTART = "PStart"; // LP primal solution warm start
enum GRB_INT_ATTR_BRANCHPRIORITY = "BranchPriority"; // MIP branch priority
enum GRB_STR_ATTR_VARNAME = "VarName"; // Variable name
enum GRB_INT_ATTR_PWLOBJCVX = "PWLObjCvx"; // Convexity of variable PWL obj
enum GRB_DBL_ATTR_VARHINTVAL = "VarHintVal";
enum GRB_INT_ATTR_VARHINTPRI = "VarHintPri";

// Constraint attributes
enum GRB_DBL_ATTR_RHS = "RHS"; // RHS
enum GRB_DBL_ATTR_DSTART = "DStart"; // LP dual solution warm start
enum GRB_CHAR_ATTR_SENSE = "Sense"; // Sense ('<', '>', or '=')
enum GRB_STR_ATTR_CONSTRNAME = "ConstrName"; // Constraint name
enum GRB_INT_ATTR_LAZY = "Lazy"; // Lazy constraint?

// Quadratic constraint attributes
enum GRB_DBL_ATTR_QCRHS = "QCRHS"; // QC RHS
enum GRB_CHAR_ATTR_QCSENSE = "QCSense"; // QC sense ('<', '>', or ' = ')
enum GRB_STR_ATTR_QCNAME = "QCName"; // QC name

// Model statistics
enum GRB_DBL_ATTR_MAX_COEFF = "MaxCoeff"; // Max (abs) nz coeff in A
enum GRB_DBL_ATTR_MIN_COEFF = "MinCoeff"; // Min (abs) nz coeff in A
enum GRB_DBL_ATTR_MAX_BOUND = "MaxBound"; // Max (abs) finite var bd
enum GRB_DBL_ATTR_MIN_BOUND = "MinBound"; // Min (abs) var bd
enum GRB_DBL_ATTR_MAX_OBJ_COEFF = "MaxObjCoeff"; // Max (abs) obj coeff
enum GRB_DBL_ATTR_MIN_OBJ_COEFF = "MinObjCoeff"; // Min (abs) obj coeff
enum GRB_DBL_ATTR_MAX_RHS = "MaxRHS"; // Max (abs) rhs coeff
enum GRB_DBL_ATTR_MIN_RHS = "MinRHS"; // Min (abs) rhs coeff

// Model solution attributes
enum GRB_DBL_ATTR_RUNTIME = "Runtime"; // Run time for optimization
enum GRB_INT_ATTR_STATUS = "Status"; // Optimization status
enum GRB_DBL_ATTR_OBJVAL = "ObjVal"; // Solution objective
enum GRB_DBL_ATTR_OBJBOUND = "ObjBound"; // Best bound on solution
enum GRB_DBL_ATTR_OBJBOUNDC = "ObjBoundC"; // Continuous bound
enum GRB_DBL_ATTR_MIPGAP = "MIPGap"; // MIP optimality gap
enum GRB_INT_ATTR_SOLCOUNT = "SolCount"; // # of solutions found
enum GRB_DBL_ATTR_ITERCOUNT = "IterCount"; // Iters performed (simplex)
enum GRB_INT_ATTR_BARITERCOUNT = "BarIterCount"; // Iters performed (barrier)
enum GRB_DBL_ATTR_NODECOUNT = "NodeCount"; // Nodes explored (B&C)
enum GRB_DBL_ATTR_OPENNODECOUNT = "OpenNodeCount"; // Unexplored nodes (B&C)
enum GRB_INT_ATTR_HASDUALNORM = "HasDualNorm"; // 0, no basis,
// 1, has basis, so can be computed
// 2, available

// Variable attributes related to the current solution
enum GRB_DBL_ATTR_X = "X"; // Solution value
enum GRB_DBL_ATTR_Xn = "Xn"; // Alternate MIP solution
enum GRB_DBL_ATTR_BARX = "BarX"; // Best barrier iterate
enum GRB_DBL_ATTR_RC = "RC"; // Reduced costs
enum GRB_DBL_ATTR_VDUALNORM = "VDualNorm"; // Dual norm square
enum GRB_INT_ATTR_VBASIS = "VBasis"; // Variable basis status

// Constraint attributes related to the current solution
enum GRB_DBL_ATTR_PI = "Pi"; // Dual value
enum GRB_DBL_ATTR_QCPI = "QCPi"; // Dual value for QC
enum GRB_DBL_ATTR_SLACK = "Slack"; // Constraint slack
enum GRB_DBL_ATTR_QCSLACK = "QCSlack"; // QC Constraint slack
enum GRB_DBL_ATTR_CDUALNORM = "CDualNorm"; // Dual norm square
enum GRB_INT_ATTR_CBASIS = "CBasis"; // Constraint basis status

// Solution quality attributes
enum GRB_DBL_ATTR_BOUND_VIO = "BoundVio";
enum GRB_DBL_ATTR_BOUND_SVIO = "BoundSVio";
enum GRB_INT_ATTR_BOUND_VIO_INDEX = "BoundVioIndex";
enum GRB_INT_ATTR_BOUND_SVIO_INDEX = "BoundSVioIndex";
enum GRB_DBL_ATTR_BOUND_VIO_SUM = "BoundVioSum";
enum GRB_DBL_ATTR_BOUND_SVIO_SUM = "BoundSVioSum";
enum GRB_DBL_ATTR_CONSTR_VIO = "ConstrVio";
enum GRB_DBL_ATTR_CONSTR_SVIO = "ConstrSVio";
enum GRB_INT_ATTR_CONSTR_VIO_INDEX = "ConstrVioIndex";
enum GRB_INT_ATTR_CONSTR_SVIO_INDEX = "ConstrSVioIndex";
enum GRB_DBL_ATTR_CONSTR_VIO_SUM = "ConstrVioSum";
enum GRB_DBL_ATTR_CONSTR_SVIO_SUM = "ConstrSVioSum";
enum GRB_DBL_ATTR_CONSTR_RESIDUAL = "ConstrResidual";
enum GRB_DBL_ATTR_CONSTR_SRESIDUAL = "ConstrSResidual";
enum GRB_INT_ATTR_CONSTR_RESIDUAL_INDEX = "ConstrResidualIndex";
enum GRB_INT_ATTR_CONSTR_SRESIDUAL_INDEX = "ConstrSResidualIndex";
enum GRB_DBL_ATTR_CONSTR_RESIDUAL_SUM = "ConstrResidualSum";
enum GRB_DBL_ATTR_CONSTR_SRESIDUAL_SUM = "ConstrSResidualSum";
enum GRB_DBL_ATTR_DUAL_VIO = "DualVio";
enum GRB_DBL_ATTR_DUAL_SVIO = "DualSVio";
enum GRB_INT_ATTR_DUAL_VIO_INDEX = "DualVioIndex";
enum GRB_INT_ATTR_DUAL_SVIO_INDEX = "DualSVioIndex";
enum GRB_DBL_ATTR_DUAL_VIO_SUM = "DualVioSum";
enum GRB_DBL_ATTR_DUAL_SVIO_SUM = "DualSVioSum";
enum GRB_DBL_ATTR_DUAL_RESIDUAL = "DualResidual";
enum GRB_DBL_ATTR_DUAL_SRESIDUAL = "DualSResidual";
enum GRB_INT_ATTR_DUAL_RESIDUAL_INDEX = "DualResidualIndex";
enum GRB_INT_ATTR_DUAL_SRESIDUAL_INDEX = "DualSResidualIndex";
enum GRB_DBL_ATTR_DUAL_RESIDUAL_SUM = "DualResidualSum";
enum GRB_DBL_ATTR_DUAL_SRESIDUAL_SUM = "DualSResidualSum";
enum GRB_DBL_ATTR_INT_VIO = "IntVio";
enum GRB_INT_ATTR_INT_VIO_INDEX = "IntVioIndex";
enum GRB_DBL_ATTR_INT_VIO_SUM = "IntVioSum";
enum GRB_DBL_ATTR_COMPL_VIO = "ComplVio";
enum GRB_INT_ATTR_COMPL_VIO_INDEX = "ComplVioIndex";
enum GRB_DBL_ATTR_COMPL_VIO_SUM = "ComplVioSum";
enum GRB_DBL_ATTR_KAPPA = "Kappa";
enum GRB_DBL_ATTR_KAPPA_EXACT = "KappaExact";
enum GRB_DBL_ATTR_N2KAPPA = "N2Kappa";

// LP sensitivity analysis
enum GRB_DBL_ATTR_SA_OBJLOW = "SAObjLow";
enum GRB_DBL_ATTR_SA_OBJUP = "SAObjUp";
enum GRB_DBL_ATTR_SA_LBLOW = "SALBLow";
enum GRB_DBL_ATTR_SA_LBUP = "SALBUp";
enum GRB_DBL_ATTR_SA_UBLOW = "SAUBLow";
enum GRB_DBL_ATTR_SA_UBUP = "SAUBUp";
enum GRB_DBL_ATTR_SA_RHSLOW = "SARHSLow";
enum GRB_DBL_ATTR_SA_RHSUP = "SARHSUp";

// IIS
enum GRB_INT_ATTR_IIS_MINIMAL = "IISMinimal"; // Boolean: Is IIS Minimal?
enum GRB_INT_ATTR_IIS_LB = "IISLB"; // Boolean: Is var LB in IIS?
enum GRB_INT_ATTR_IIS_UB = "IISUB"; // Boolean: Is var UB in IIS?
enum GRB_INT_ATTR_IIS_CONSTR = "IISConstr"; // Boolean: Is constr in IIS?
enum GRB_INT_ATTR_IIS_SOS = "IISSOS"; // Boolean: Is SOS in IIS?
enum GRB_INT_ATTR_IIS_QCONSTR = "IISQConstr"; // Boolean: Is QConstr in IIS?

// Tuning
enum GRB_INT_ATTR_TUNE_RESULTCOUNT = "TuneResultCount";

// advanced simplex features
enum GRB_DBL_ATTR_FARKASDUAL = "FarkasDual";
enum GRB_DBL_ATTR_FARKASPROOF = "FarkasProof";
enum GRB_DBL_ATTR_UNBDRAY = "UnbdRay";
enum GRB_INT_ATTR_INFEASVAR = "InfeasVar";
enum GRB_INT_ATTR_UNBDVAR = "UnbdVar";

// Presolve attribute
enum GRB_INT_ATTR_VARPRESTAT = "VarPreStat";
enum GRB_DBL_ATTR_PREFIXVAL = "PreFixVal";

enum GRB_INT_PAR_BARITERLIMIT = "BarIterLimit";
enum GRB_DBL_PAR_CUTOFF = "Cutoff";
enum GRB_DBL_PAR_ITERATIONLIMIT = "IterationLimit";
enum GRB_DBL_PAR_NODELIMIT = "NodeLimit";
enum GRB_INT_PAR_SOLUTIONLIMIT = "SolutionLimit";
enum GRB_DBL_PAR_TIMELIMIT = "TimeLimit";

// Tolerances
enum GRB_DBL_PAR_FEASIBILITYTOL = "FeasibilityTol";
enum GRB_DBL_PAR_INTFEASTOL = "IntFeasTol";
enum GRB_DBL_PAR_MARKOWITZTOL = "MarkowitzTol";
enum GRB_DBL_PAR_MIPGAP = "MIPGap";
enum GRB_DBL_PAR_MIPGAPABS = "MIPGapAbs";
enum GRB_DBL_PAR_OPTIMALITYTOL = "OptimalityTol";
enum GRB_DBL_PAR_PSDTOL = "PSDTol";

// Simplex
enum GRB_INT_PAR_METHOD = "Method";
enum GRB_DBL_PAR_PERTURBVALUE = "PerturbValue";
enum GRB_DBL_PAR_OBJSCALE = "ObjScale";
enum GRB_INT_PAR_SCALEFLAG = "ScaleFlag";
enum GRB_INT_PAR_SIMPLEXPRICING = "SimplexPricing";
enum GRB_INT_PAR_QUAD = "Quad";
enum GRB_INT_PAR_NORMADJUST = "NormAdjust";
enum GRB_INT_PAR_SIFTING = "Sifting";
enum GRB_INT_PAR_SIFTMETHOD = "SiftMethod";

// Barrier
enum GRB_DBL_PAR_BARCONVTOL = "BarConvTol";
enum GRB_INT_PAR_BARCORRECTORS = "BarCorrectors";
enum GRB_INT_PAR_BARHOMOGENEOUS = "BarHomogeneous";
enum GRB_INT_PAR_BARORDER = "BarOrder";
enum GRB_DBL_PAR_BARQCPCONVTOL = "BarQCPConvTol";
enum GRB_INT_PAR_CROSSOVER = "Crossover";
enum GRB_INT_PAR_CROSSOVERBASIS = "CrossoverBasis";

// MIP
enum GRB_INT_PAR_BRANCHDIR = "BranchDir";
enum GRB_INT_PAR_DISCONNECTED = "Disconnected";
enum GRB_DBL_PAR_HEURISTICS = "Heuristics";
enum GRB_DBL_PAR_IMPROVESTARTGAP = "ImproveStartGap";
enum GRB_DBL_PAR_IMPROVESTARTTIME = "ImproveStartTime";
enum GRB_DBL_PAR_IMPROVESTARTNODES = "ImproveStartNodes";
enum GRB_INT_PAR_MINRELNODES = "MinRelNodes";
enum GRB_INT_PAR_MIPFOCUS = "MIPFocus";
enum GRB_STR_PAR_NODEFILEDIR = "NodefileDir";
enum GRB_DBL_PAR_NODEFILESTART = "NodefileStart";
enum GRB_INT_PAR_NODEMETHOD = "NodeMethod";
enum GRB_INT_PAR_NORELHEURISTIC = "NoRelHeuristic";
enum GRB_INT_PAR_PUMPPASSES = "PumpPasses";
enum GRB_INT_PAR_RINS = "RINS";
enum GRB_INT_PAR_SUBMIPNODES = "SubMIPNodes";
enum GRB_INT_PAR_SYMMETRY = "Symmetry";
enum GRB_INT_PAR_VARBRANCH = "VarBranch";
enum GRB_INT_PAR_SOLUTIONNUMBER = "SolutionNumber";
enum GRB_INT_PAR_ZEROOBJNODES = "ZeroObjNodes";

// MIP cuts
enum GRB_INT_PAR_CUTS = "Cuts";
enum GRB_INT_PAR_CLIQUECUTS = "CliqueCuts";
enum GRB_INT_PAR_COVERCUTS = "CoverCuts";
enum GRB_INT_PAR_FLOWCOVERCUTS = "FlowCoverCuts";
enum GRB_INT_PAR_FLOWPATHCUTS = "FlowPathCuts";
enum GRB_INT_PAR_GUBCOVERCUTS = "GUBCoverCuts";
enum GRB_INT_PAR_IMPLIEDCUTS = "ImpliedCuts";
enum GRB_INT_PAR_MIPSEPCUTS = "MIPSepCuts";
enum GRB_INT_PAR_MIRCUTS = "MIRCuts";
enum GRB_INT_PAR_MODKCUTS = "ModKCuts";
enum GRB_INT_PAR_ZEROHALFCUTS = "ZeroHalfCuts";
enum GRB_INT_PAR_NETWORKCUTS = "NetworkCuts";
enum GRB_INT_PAR_SUBMIPCUTS = "SubMIPCuts";
enum GRB_INT_PAR_CUTAGGPASSES = "CutAggPasses";
enum GRB_INT_PAR_CUTPASSES = "CutPasses";
enum GRB_INT_PAR_GOMORYPASSES = "GomoryPasses";

// Distributed algorithms
enum GRB_STR_PAR_WORKERPOOL = "WorkerPool";
enum GRB_STR_PAR_WORKERPASSWORD = "WorkerPassword";
enum GRB_INT_PAR_WORKERPORT = "WorkerPort";

// Other
enum GRB_INT_PAR_AGGREGATE = "Aggregate";
enum GRB_INT_PAR_AGGFILL = "AggFill";
enum GRB_INT_PAR_CONCURRENTMIP = "ConcurrentMIP";
enum GRB_INT_PAR_CONCURRENTJOBS = "ConcurrentJobs";
enum GRB_INT_PAR_DISPLAYINTERVAL = "DisplayInterval";
enum GRB_INT_PAR_DISTRIBUTEDMIPJOBS = "DistributedMIPJobs";
enum GRB_INT_PAR_DUALREDUCTIONS = "DualReductions";
enum GRB_DBL_PAR_FEASRELAXBIGM = "FeasRelaxBigM";
enum GRB_INT_PAR_IISMETHOD = "IISMethod";
enum GRB_INT_PAR_INFUNBDINFO = "InfUnbdInfo";
enum GRB_INT_PAR_LAZYCONSTRAINTS = "LazyConstraints";
enum GRB_STR_PAR_LOGFILE = "LogFile";
enum GRB_INT_PAR_LOGTOCONSOLE = "LogToConsole";
enum GRB_INT_PAR_MIQCPMETHOD = "MIQCPMethod";
enum GRB_INT_PAR_NUMERICFOCUS = "NumericFocus";
enum GRB_INT_PAR_OUTPUTFLAG = "OutputFlag";
enum GRB_INT_PAR_PRECRUSH = "PreCrush";
enum GRB_INT_PAR_PREDEPROW = "PreDepRow";
enum GRB_INT_PAR_PREDUAL = "PreDual";
enum GRB_INT_PAR_PREPASSES = "PrePasses";
enum GRB_INT_PAR_PREQLINEARIZE = "PreQLinearize";
enum GRB_INT_PAR_PRESOLVE = "Presolve";
enum GRB_DBL_PAR_PRESOS1BIGM = "PreSOS1BigM";
enum GRB_DBL_PAR_PRESOS2BIGM = "PreSOS2BigM";
enum GRB_INT_PAR_PRESPARSIFY = "PreSparsify";
enum GRB_INT_PAR_PREMIQCPFORM = "PreMIQCPForm";
enum GRB_INT_PAR_QCPDUAL = "QCPDual";
enum GRB_INT_PAR_RECORD = "Record";
enum GRB_STR_PAR_RESULTFILE = "ResultFile";
enum GRB_INT_PAR_SEED = "Seed";
enum GRB_INT_PAR_THREADS = "Threads";
enum GRB_DBL_PAR_TUNETIMELIMIT = "TuneTimeLimit";
enum GRB_INT_PAR_TUNERESULTS = "TuneResults";
enum GRB_INT_PAR_TUNETRIALS = "TuneTrials";
enum GRB_INT_PAR_TUNEOUTPUT = "TuneOutput";
enum GRB_INT_PAR_TUNEJOBS = "TuneJobs";
enum GRB_INT_PAR_UPDATEMODE = "UpdateMode";
enum GRB_STR_PAR_DUMMY = "Dummy";

/* Query interface */
extern (Windows)
{
  int GRBgetattrinfo(GRBmodel* model, char* attrname, int* datatypeP, int* sizeP, int* settableP);
  int GRBisattravailable(GRBmodel* model, char* attrname);
  int GRBgetintattr(GRBmodel* model, char* attrname, int* valueP);
  int GRBsetintattr(GRBmodel* model, char* attrname, int newvalue);
  int GRBgetintattrelement(GRBmodel* model, char* attrname, int element, int* valueP);
  int GRBsetintattrelement(GRBmodel* model, char* attrname, int element, int newvalue);
  int GRBgetintattrarray(GRBmodel* model, char* attrname, int first, int len, int* values);
  int GRBsetintattrarray(GRBmodel* model, char* attrname, int first, int len, int* newvalues);
  int GRBgetintattrlist(GRBmodel* model, char* attrname, int len, int* ind, int* values);
  int GRBsetintattrlist(GRBmodel* model, char* attrname, int len, int* ind, int* newvalues);
  int GRBgetcharattrelement(GRBmodel* model, char* attrname, int element, char* valueP);
  int GRBsetcharattrelement(GRBmodel* model, char* attrname, int element, char newvalue);
  int GRBgetcharattrarray(GRBmodel* model, char* attrname, int first, int len, char* values);
  int GRBsetcharattrarray(GRBmodel* model, char* attrname, int first, int len, char* newvalues);
  int GRBgetcharattrlist(GRBmodel* model, char* attrname, int len, int* ind, char* values);
  int GRBsetcharattrlist(GRBmodel* model, char* attrname, int len, int* ind, char* newvalues);
  int GRBgetdblattr(GRBmodel* model, char* attrname, double* valueP);
  int GRBsetdblattr(GRBmodel* model, char* attrname, double newvalue);
  int GRBgetdblattrelement(GRBmodel* model, char* attrname, int element, double* valueP);
  int GRBsetdblattrelement(GRBmodel* model, char* attrname, int element, double newvalue);
  int GRBgetdblattrarray(GRBmodel* model, char* attrname, int first, int len, double* values);
  int GRBsetdblattrarray(GRBmodel* model, char* attrname, int first, int len, double* newvalues);
  int GRBgetdblattrlist(GRBmodel* model, char* attrname, int len, int* ind, double* values);
  int GRBsetdblattrlist(GRBmodel* model, char* attrname, int len, int* ind, double* newvalues);
  int GRBgetstrattr(GRBmodel* model, char* attrname, char** valueP);
  int GRBsetstrattr(GRBmodel* model, char* attrname, char* newvalue);
  int GRBgetstrattrelement(GRBmodel* model, char* attrname, int element, char** valueP);
  int GRBsetstrattrelement(GRBmodel* model, char* attrname, int element, char* newvalue);
  int GRBgetstrattrarray(GRBmodel* model, char* attrname, int first, int len, char** values);
  int GRBsetstrattrarray(GRBmodel* model, char* attrname, int first, int len, char** newvalues);
  int GRBgetstrattrlist(GRBmodel* model, char* attrname, int len, int* ind, char** values);
  int GRBsetstrattrlist(GRBmodel* model, char* attrname, int len, int* ind, char** newvalues);
  int GRBsetcallbackfunc(GRBmodel* model, int function(GRBmodel* model,
    void* cbdata, int where, void* usrdata) cb, void* usrdata);
  int GRBgetcallbackfunc(GRBmodel* model, int function(GRBmodel* model,
    void* cbdata, int where, void* usrdata)* cbP);
  int GRBsetlogcallbackfunc(GRBmodel* model, int function(char* msg) cb);
  int GRBsetlogcallbackfuncenv(GRBenv* env, int function(char* msg) cb);
  int GRBcbget(void* cbdata, int where, int what, void* resultP);
  int GRBcbsetparam(void* cbdata, char* paramname, char* newvalue);
  int GRBcbsolution(void* cbdata, double* solution);
  int GRBcbcut(void* cbdata, int cutlen, int* cutind, double* cutval, char cutsense,
    double cutrhs);
  int GRBcblazy(void* cbdata, int lazylen, int* lazyind, double* lazyval,
    char lazysense, double lazyrhs);
  int GRBgetcoeff(GRBmodel* model, int constr, int var, double* valP);
  int GRBgetconstrs(GRBmodel* model, int* numnzP, int* cbeg, int* cind,
    double* cval, int start, int len);
  int GRBgetvars(GRBmodel* model, int* numnzP, int* vbeg, int* vind,
    double* vval, int start, int len);
  int GRBgetsos(GRBmodel* model, int* nummembersP, int* sostype, int* beg,
    int* ind, double* weight, int start, int len);
  int GRBgetq(GRBmodel* model, int* numqnzP, int* qrow, int* qcol, double* qval);
  int GRBgetqconstr(GRBmodel* model, int qconstr, int* numlnzP, int* lind,
    double* lval, int* numqnzP, int* qrow, int* qcol, double* qval);
  int GRBgetvarbyname(GRBmodel* model, char* name, int* indexP);
  int GRBgetconstrbyname(GRBmodel* model, char* name, int* indexP);
  int GRBgetpwlobj(GRBmodel* model, int var, int* pointsP, double* x, double* y);
  int GRBoptimize(GRBmodel* model);
  int GRBoptimizeasync(GRBmodel* model);
  int GRBfeasrelax(GRBmodel* model, int relaxobjtype, int minrelax,
    double* lbpen, double* ubpen, double* rhspen, double* feasobjP);
  int GRBreadmodel(GRBenv* env, char* filename, GRBmodel** modelP);
  int GRBread(GRBmodel* model, char* filename);
  int GRBwrite(GRBmodel* model, char* filename);
  int GRBnewmodel(GRBenv* env, GRBmodel** modelP, char* Pname, int numvars,
    double* obj, double* lb, double* ub, char* vtype, char** varnames);
  int GRBloadmodel(GRBenv* env, GRBmodel** modelP, char* Pname, int numvars,
    int numconstrs, int objsense, double objcon, double* obj, char* sense,
    double* rhs, int* vbeg, int* vlen, int* vind, double* vval, double* lb,
    double* ub, char* vtype, char** varnames, char** constrnames);
  int GRBaddvar(GRBmodel* model, int numnz, int* vind, double* vval, double obj,
    double lb, double ub, char vtype, char* varname);
  int GRBaddvars(GRBmodel* model, int numvars, int numnz, int* vbeg, int* vind,
    double* vval, double* obj, double* lb, double* ub, char* vtype, char** varnames);
  int GRBaddconstr(GRBmodel* model, int numnz, int* cind, double* cval,
    char sense, double rhs, char* constrname);
  int GRBaddconstrs(GRBmodel* model, int numconstrs, int numnz, int* cbeg,
    int* cind, double* cval, char* sense, double* rhs, char** constrnames);
  int GRBaddrangeconstr(GRBmodel* model, int numnz, int* cind, double* cval,
    double lower, double upper, char* constrname);
  int GRBaddrangeconstrs(GRBmodel* model, int numconstrs, int numnz, int* cbeg,
    int* cind, double* cval, double* lower, double* upper, char** constrnames);
  int GRBaddsos(GRBmodel* model, int numsos, int nummembers, int* types,
    int* beg, int* ind, double* weight);
  int GRBaddqconstr(GRBmodel* model, int numlnz, int* lind, double* lval,
    int numqnz, int* qrow, int* qcol, double* qval, char sense, double rhs, char* QCname);
  int GRBaddcone(GRBmodel* model, int nummembers, int* members);
  int GRBaddqpterms(GRBmodel* model, int numqnz, int* qrow, int* qcol, double* qval);
  int GRBdelvars(GRBmodel* model, int len, int* ind);
  int GRBdelconstrs(GRBmodel* model, int len, int* ind);
  int GRBdelsos(GRBmodel* model, int len, int* ind);
  int GRBdelqconstrs(GRBmodel* model, int len, int* ind);
  int GRBdelq(GRBmodel* model);
  int GRBchgcoeffs(GRBmodel* model, int cnt, int* cind, int* vind, double* val);
  int GRBsetpwlobj(GRBmodel* model, int var, int points, double* x, double* y);
  int GRBupdatemodel(GRBmodel* model);
  int GRBresetmodel(GRBmodel* model);
  int GRBfreemodel(GRBmodel* model);
  int GRBcomputeIIS(GRBmodel* model);
  int GRBFSolve(GRBmodel* model, GRBsvec* b, GRBsvec* x);
  int GRBBinvColj(GRBmodel* model, int j, GRBsvec* x);
  int GRBBinvj(GRBmodel* model, int j, GRBsvec* x);
  int GRBBSolve(GRBmodel* model, GRBsvec* b, GRBsvec* x);
  int GRBBinvi(GRBmodel* model, int i, GRBsvec* x);
  int GRBBinvRowi(GRBmodel* model, int i, GRBsvec* x);
  int GRBgetBasisHead(GRBmodel* model, int* bhead);
  int GRBcheckmodel(GRBmodel* model);
  int GRBreplay(char* filename);
  int GRBgetintparam(GRBenv* env, char* paramname, int* valueP);
  int GRBgetdblparam(GRBenv* env, char* paramname, double* valueP);
  int GRBgetstrparam(GRBenv* env, char* paramname, char* valueP);
  int GRBgetintparaminfo(GRBenv* env, char* paramname, int* valueP,
    int* minP, int* maxP, int* defP);
  int GRBgetdblparaminfo(GRBenv* env, char* paramname, double* valueP,
    double* minP, double* maxP, double* defP);
  int GRBgetstrparaminfo(GRBenv* env, char* paramname, char* valueP, char* defP);
  int GRBsetparam(GRBenv* env, char* paramname, char* value);
  int GRBsetintparam(GRBenv* env, char* paramname, int value);
  int GRBsetdblparam(GRBenv* env, char* paramname, double value);
  int GRBsetstrparam(GRBenv* env, char* paramname, char* value);
  int GRBgetparamtype(GRBenv* env, char* paramname);
  int GRBresetparams(GRBenv* env);
  int GRBcopyparams(GRBenv* dest, GRBenv* src);
  int GRBwriteparams(GRBenv* env, char* filename);
  int GRBreadparams(GRBenv* env, char* filename);
  int GRBgetnumparams(GRBenv* env);
  int GRBgetparamname(GRBenv* env, int i, char** paramnameP);
  int GRBgetnumattributes(GRBmodel* model);
  int GRBgetattrname(GRBmodel* model, int i, char** attrnameP);
  int GRBloadenv(GRBenv** envP, char* logfilename);
  int GRBloadenvadv(GRBenv** envP, char* logfilename,
    int function(GRBmodel* model, void* cbdata, int where, void* usrdata) cb, void* usrdata);
  int GRBloadclientenv(GRBenv** envP, char* logfilename, char* computeservers,
    int port, char* password, int priority, double timeout);
  int GRBloadclientenvadv(GRBenv** envP, char* logfilename,
    char* computeservers, int port, char* password, int priority, double timeout,
    int function(GRBmodel* model, void* cbdata, int where, void* usrdata) cb, void* usrdata);
  int GRBlisttokens();
  int GRBlistclients(char* computeServer, int port);
  int GRBchangeuserpassword(char* computeServer, int port, char* admin_password,
    char* new_user_password);
  int GRBchangeadminpassword(char* computeServer, int port,
    char* admin_password, char* new_admin_password);
  int GRBchangejoblimit(char* computeServer, int port, int newlimit, char* admin_password);
  int GRBkilljob(char* computeServer, int port, char* jobID, char* admin_password);
  int GRBtunemodel(GRBmodel* model);
  int GRBtunemodels(int nummodels, GRBmodel** models, GRBmodel* ignore, GRBmodel* hint);
  int GRBgettuneresult(GRBmodel* model, int i);
  int GRBgettunelog(GRBmodel* model, int i, char** logP);
  int GRBtunemodeladv(GRBmodel* model, GRBmodel* ignore, GRBmodel* hint);
  int GRBsync(GRBmodel* model);

  void GRBsetsignal(GRBmodel* model);
  void GRBterminate(GRBmodel* model);
  void GRBclean2(int* lenP, int* ind, double* val);
  void GRBclean3(int* lenP, int* ind0, int* ind1, double* val);
  void GRBmsg(GRBenv* env, char* message);
  void GRBdiscardconcurrentenvs(GRBmodel* model);
  void GRBreleaselicense(GRBenv* env);
  void GRBfreeenv(GRBenv* env);
  void GRBversion(int* majorP, int* minorP, int* technicalP);

  char* GRBgeterrormsg(GRBenv* env);
  char* GRBgetmerrormsg(GRBmodel* model);
  char* GRBplatform();

  GRBmodel* GRBcopymodel(GRBmodel* model);
  GRBmodel* GRBfixedmodel(GRBmodel* model);
  GRBenv* GRBgetenv(GRBmodel* model);
  GRBenv* GRBgetconcurrentenv(GRBmodel* model, int num);

  // Undocumented routines
  int GRBgetcbwhatinfo(void* cbdata, int what, int* typeP, int* sizeP);
  int GRBconverttofixed(GRBmodel* model);
  int GRBstrongbranch(GRBmodel* model, int num, int* cand, double* downobjbd,
    double* upobjbd, int* statusP);
  GRBmodel* GRBrelaxmodel(GRBmodel* model);
  GRBmodel* GRBpresolvemodel(GRBmodel* model);
  GRBmodel* GRBiismodel(GRBmodel* model);
  GRBmodel* GRBfeasibility(GRBmodel* model);
  GRBmodel* GRBlinearizemodel(GRBmodel* model);

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
