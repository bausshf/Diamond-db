/**
* Copyright © DiamondMVC 2017
* License: MIT (https://github.com/DiamondMVC/Diamond-db/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.database.core.traits;

/// Mixin template to handle fields of a type.
mixin template HandleFields(T, string handler)
{
	string handleThem()
	{
		mixin HandleField!(T, [FieldNameTuple!T][0], T.stringof ~ "." ~ [FieldNameTuple!T][0], 1, [FieldNameTuple!T], handler);

		return handle();
	}
}

/// Mixin template to handle a specific field of a fieldname collection.
mixin template HandleField(T, string fieldName, string fullName, size_t index, string[] fieldNames, string handler)
{
  import std.array : replace;
  import std.conv : to;

	static if (index == 1)
	{
		string handle()
		{
			string s = handler.replace("{{fieldName}}", fieldName).replace("{{fullName}}", fullName).replace("{{index}}", to!string(index - 2));

			static if (fieldNames.length > 1)
			{
				mixin("s ~= handle_" ~ fieldNames[index] ~ "();");
			}

			return s;
		}
	}
	else
	{
		static if (index < fieldNames.length)
		{
			mixin("string handle_" ~ fieldName ~ "() { string s = handler.replace(\"{{fieldName}}\", fieldName).replace(\"{{fullName}}\", fullName).replace(\"{{index}}\", \"" ~ to!string(index - 2) ~ "\"); s ~= handle_" ~ fieldNames[index] ~ "(); return s; }");
		}
		else
		{
			mixin("string handle_" ~ fieldName ~ "() { return handler.replace(\"{{fieldName}}\", fieldName).replace(\"{{fullName}}\", fullName).replace(\"{{index}}\", \"" ~ to!string(index - 2) ~ "\"); }");
		}
	}

	static if (index < fieldNames.length)
	{
		mixin HandleField!(T, fieldNames[index], T.stringof ~ "." ~ fieldNames[index], index + 1, fieldNames, handler);
	}
}
