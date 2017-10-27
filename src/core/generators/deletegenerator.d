/**
* Copyright © DiamondMVC 2017
* License: MIT (https://github.com/DiamondMVC/Diamond-db/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.database.core.generators.deletegenerator;

import std.string : format;
import std.traits : hasUDA, FieldNameTuple;

import diamond.database.core.traits;
import diamond.database.core.attributes;
import diamond.database.engine.model : IDatabaseModel;

package(diamond.database):
/**
* Generates the delete function for a database model.
* Returns:
*   The delete function string to use with mixin.
*/
string generateDelete(T : IDatabaseModel)()
{
  import models;

  string s = q{
    _deleter =
    {
      static const sql = "DELETE FROM `%s` WHERE `%s` = ?";
      auto params = getParams(1);

      %s

      MySql.executeRaw(sql, params);
    };
  };

  string idName;
  string idParams;

  {
    mixin HandleFields!(T, q{{
      enum hasId = hasUDA!({{fullName}}, DbId);

      static if (hasId)
      {
        idName = "{{fieldName}}";
        idParams = "params[0] = model.{{fieldName}};";
      }
    }});
    mixin(handleThem());

    if (!idName)
    {
      return "";
    }
  }

  return s.format(T.table, idName, idParams);
}
