# Diamond-db

Diamond-db is a high-performance ORM based on mysql-native which is compatible with Diamond's MVC Framework.

All models used by the ORM must be accessible by the module *models*.

Example:

Model:

```
class MyModel : DatabaseModel!"mymodel_table"
{
  public:
  @DbId ulong id;
  string name;

  this() { super(); }
}
```

Reading:

```
import diamond.database;
import models;

auto params = getParams();
params["id"] = cast(ulong)1;

auto model = MySql.readSingle!MyModel("SELECT * FROM `@table` WHERE `id` = @id", params);
```
