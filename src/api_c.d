// vim: set ft=d ts=2 sw=2 et :
// dmd -c gurobi.d
module api_c;

private {
  import error_codes;
  import callback;
  import params;
  import attributes;
}

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
