/**
* Copyright © DiamondMVC 2017
* License: MIT (https://github.com/DiamondMVC/Diamond-db/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.database.engine.model;

import std.traits : hasUDA;
import std.string : format;
import std.datetime : Date, DateTime, Clock, SysTime;

import vibe.data.serialization : ignore;

import diamond.database.core.attributes;
import diamond.database.core.generators;
import diamond.database : getParams, MySql;

/// Base-interface for a database model.
interface IDatabaseModel { }


/**
* Converts a SysTime to a DateTime.
*	Params:
*		sysTime = The SysTime to convert.
*	Returns:
*		The converted DateTime.
*/
private DateTime asDateTime(SysTime sysTime)
{
	return DateTime(sysTime.year, sysTime.month, sysTime.day, sysTime.hour, sysTime.minute, sysTime.second);
}

/**
* Creates a new database model.
*	Params:
*		tableName = The name of the table the model is associated with.
*/
class DatabaseModel(string tableName) : IDatabaseModel
{
  import mysql.db : Row;

  private
  {
		/// The row.
    Row _row;
		/// The index.
    size_t _index;
		/// The reader.
    void delegate() _reader;
		/// The inserter.
    void delegate() _inserter;
		/// The updater.
    void delegate() _updater;
		/// The deleter.
    void delegate() _deleter;

		/**
		* Retrieves a value from the row.
		*	Params:
		*		T =        The type.
		*		nullable = Boolean determining whether the value is nullable or not.
		*		isEnum = 	 Boolean determining whether the value is an enum or not.
		*		column = 	 The column index of the value.
		*	Returns:
		*		The value.
		*/
    final T retrieve(T, bool nullable = false, bool isEnum = false)(size_t column) @system
    {
      import std.traits : OriginalType;

      static if (nullable && isEnum)
      {
        return cast(T)(_row.isNull(column) ? T.init : _row[column].get!(OriginalType!T));
      }
      else static if (isEnum)
      {
        return cast(T)(_row[column].get!(OriginalType!T));
      }
      else static if (nullable)
      {
        return _row.isNull(column) ? T.init : _row[column].get!T;
      }
			else static if (is(T == bool))
			{
				return cast(bool)_row[column].get!ubyte;
			}
      else
      {
        return _row[column].get!T;
      }
    }

		/**
		* Retrieves a value from the row.
		*	Params:
		*		T =        The type.
		*		nullable = Boolean determining whether the value is nullable or not.
		*		isEnum = 	 Boolean determining whether the value is an enum or not.
		*	Returns:
		*		The value.
		*/
    final T retrieve(T, bool nullable = false, bool isEnum = false)() @system
    {
      auto value = retrieve!(T, nullable, isEnum)(_index);
      _index++;
      return value;
    }
  }

  public:
  final:
	/// The table name.
  @ignore static const string table = tableName;

	/// Creates a new database model.
  this(this TModel)()
  {
    auto model = cast(TModel)this;

    enum readNullEnumFomat = "model.%s = retrieve!(%s, true, true);";
    enum readNullFomat = "model.%s = retrieve!(%s, true, false);";
    enum readEnumFomat = "model.%s = retrieve!(%s, false, true);";
		enum readBoolFormat = "model.%s = retrieve!(%s);";
    enum readFomat = "model.%s = retrieve!(%s);";

    import models;
    mixin(generateRead!TModel);
    mixin(generateInsert!TModel);
    mixin(generateUpdate!TModel);
    mixin(generateDelete!TModel);
  }

  @property
  {
		/// Gets the raw row.
    @ignore Row row() @system { return _row; }

		/// Sets the native row. Settings this manually outside the engine is undefined-behavior.
    @ignore void row(Row newRow)  @system
    {
      _row = newRow;
    }
  }

	/// Reads the model from the reader. Called internally from readSingle & readMany
  void readModel() @system
  {
    if (_reader)
    {
      _reader();
    }
  }

	/// Inserts the model.
  void insertModel() @system
  {
    if (_inserter)
    {
      _inserter();
    }
  }

	/// Updates the model.
  void updateModel() @system
  {
    if (_updater)
    {
      _updater();
    }
  }

	/// Deletes the model.
  void deleteModel() @system
  {
    if (_deleter)
    {
      _deleter();
    }
  }
}
// TODO: Optimize these to do CTFE:

/**
* Inserts an array of models.
*	Params:
*		models = The models to insert.
*/
void insertMany(T : IDatabaseModel)(T[] models) @system
{
  foreach (model; models)
  {
    model.insertModel();
  }
}

/**
* Updates an array of models.
*	Params:
*		models = The models to update.
*/
void updateMany(T : IDatabaseModel)(T[] models) @system
{
  foreach (model; models)
  {
    model.updateModel();
  }
}

/**
* Deletes an array of models.
*	Params:
*		models = The models to delete.
*/
void deleteMany(T : IDatabaseModel)(T[] models) @system
{
  foreach (model; models)
  {
    model.deleteModel();
  }
}
