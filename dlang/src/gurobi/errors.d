// vim: set ft=d ts=2 sw=2 et :
// dmd -c gurobi.d
module errors;

// Error codes

enum ErrorCode : int {
  OUT_OF_MEMORY            = 10001,
  NULL_ARGUMENT            = 10002,
  INVALID_ARGUMENT         = 10003,
  UNKNOWN_ATTRIBUTE        = 10004,
  DATA_NOT_AVAILABLE       = 10005,
  INDEX_OUT_OF_RANGE       = 10006,
  UNKNOWN_PARAMETER        = 10007,
  VALUE_OUT_OF_RANGE       = 10008,
  NO_LICENSE               = 10009,
  SIZE_LIMIT_EXCEEDED      = 10010,
  CALLBACK                 = 10011,
  FILE_READ                = 10012,
  FILE_WRITE               = 10013,
  NUMERIC                  = 10014,
  IIS_NOT_INFEASIBLE       = 10015,
  NOT_FOR_MIP              = 10016,
  OPTIMIZATION_IN_PROGRESS = 10017,
  DUPLICATES               = 10018,
  NODEFILE                 = 10019,
  Q_NOT_PSD                = 10020,
  QCP_EQUALITY_CONSTRAINT  = 10021,
  NETWORK                  = 10022,
  JOB_REJECTED             = 10023,
  NOT_SUPPORTED            = 10024,
  EXCEED_2B_NONZEROS       = 10025,
  INVALID_PIECEWISE_OBJ    = 10026,
  UPDATEMODE_CHANGE        = 10027,
}
