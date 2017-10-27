/**
* Copyright © DiamondMVC 2017
* License: MIT (https://github.com/DiamondMVC/Diamond-db/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.database;

import std.variant : Variant;

public
{
  import std.datetime : Date, DateTime, Clock, SysTime;

  import diamond.database.core;
  import diamond.database.engine;

  /// A variant db parameter type.
  alias DbParam = Variant;
}

/// Gets an associative array to use for specialized parameters.
auto getParams()
{
  DbParam[string] params;

  return params;
}

/// Gets a static-sized array to use for raw sql statements.
auto getParams(size_t count)
{
  return new DbParam[count];
}
