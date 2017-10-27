# Diamond-db

Diamond-db is a high-performance ORM based on mysql-native which is compatible with Diamond's MVC Framework.

All models used by the ORM must be accessible by the module *models*.

## Example

### Model

```
class MyModel : DatabaseModel!"mymodel_table"
{
  public:
  @DbId ulong id;
  string name;

  this() { super(); }
}
```

### Read Single

```
import diamond.database;
import models;

static const sql = "SELECT * FROM `@table` WHERE `id` = @id";

auto params = getParams();
params["id"] = cast(ulong)1;

auto model = MySql.readSingle!MyModel(sql, params);
```

### Read Many

```
import diamond.database;
import models;

static const sql = "SELECT * FROM `@table`";

auto models = MySql.readMany!MyModel(sql, null);
```

### Insert

```
import models;

auto model = new MyModel;
model.name = "Bob";

model.insertModel();
```

### Insert Many

```
import models;
import diamond.database;

auto model1 = new MyModel;
model1.name = "Bob";

auto model2 = new MyModel;
model2.name = "Sally";

auto models = [model1, model2];

models.insertModel();
```

### Update

```
import models;

auto model = new MyModel;
model.id = 1;
model.name = "ThisIsNotBobAnymore";

model.updateModel();
```

### UpdateMany

```
import models;
import diamond.database;

auto model1 = new MyModel;
model1.id = 1;
model1.name = "ThisIsNotBobAnymore";

auto model2 = new MyModel;
model2.id = 2;
model2.name = "ThisIsNotSallyAnymore";

auto models = [model1, model2];

models.updateModel();
```

### Delete

```
import models;

auto model = new MyModel;
model.id = 1;

model.deleteModel();
```

### Delete Many

```
import models;
import diamond.database;

auto model1 = new MyModel;
model1.id = 1;

auto model2 = new MyModel;
model2.id = 2;

auto models = [model1, model2];

models.deleteModel();
```
