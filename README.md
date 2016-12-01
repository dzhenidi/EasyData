EasyData
========

EasyData is a lightweight framework that facilitates SQL record manipulation through object relational mapping. It is inspired by Rails' ActiveRecord, and, similarly to `ActiveRecord::Base`, converts database tables into instances of the `SQLObject` class and encapsulates SQL queries in simple ruby operations.
The library follows Rails' naming conventions for tables and models and provides default arguments for the associations methods.

Methods
-------

###CRUD methods:
* `::create`
* `#update`
* `#destroy`

###Query methods:
* `::all`
* `::find`
* `::where`

###Associations:
* `::belongs_to`
* `::has_many`
* `::has_one_through`
* `::has_many_through`

To use:
-------
**1.** Clone this repo

**2.** Update the db_connection.rb file with the relative path to your .sql file in the root directory
```ruby
BIKELOVE_SQL_FILE = File.join(ROOT_FOLDER, 'bikelove.sql')
BIKELOVE_DB_FILE = File.join(ROOT_FOLDER, 'bikelove.db')
```
**3.** Create a model class for each table in your database and use the  methods described below for CRUD, queries and associations
* Call `#finalize!` at the end of your model class definition, in order to have getter/setter methods defined.

To demo:
-------
**1.** Clone this repo

**2.** Load pry, or your preferred REPL, from the /lib directory

**3.** Load the demo script
```ruby
$pry
[1] pry(main)> load 'demo.rb'
welcome to EasyData!
```
**4.** Test the methods listed above, e.g.:
```ruby
[3] pry(main)> Bike.where(id: 1)[0].biker.fname
=> "Frank"
```
**5.** To see what else is in the demo database schema:
```ruby
$ sqlite3 bikelove.db
```



EasyData uses:
--------------

`activesupport`


Implementation Details:
-----------------------
* Uses `ActiveSupport` to infer the name of the table given the model,
use `::table_name=` to override the default.
* The associations methods provide default values for the options argument   

```ruby
class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name}_id".to_sym,
      :primary_key => :id,
      :class_name => name.to_s.camelcase
    }

    options = defaults.merge(options)
    options.keys.each do |key|
      send("#{key}=", options[key])
    end
  end
end
```

TODO:
-----
* Expand query interface to include `::includes` and `::joins`. Through eager load, `::includes` will ensure associations are loaded using the minimum possible number of queries, solving the n+1 query problem.
* Make query methods lazy and stackable
* Include validations
