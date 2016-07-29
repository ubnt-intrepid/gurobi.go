module env;

private import api_c;

class Env
{
  GRBenv* env;

public:
  this(string logfilename)
  {
    int error = GRBloadenv(&env, cast(char*) logfilename);
    if (error)
      throw new Exception("cannot load environment");
  }

  ~this()
  {
    // Free environment
    GRBfreeenv(env);
  }

  GRBenv* get()
  {
    return env;
  }
}
