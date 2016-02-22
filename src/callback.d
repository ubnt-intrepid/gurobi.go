// vim: set ft=d ts=2 sw=2 et :
// For callback
module callback;

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
