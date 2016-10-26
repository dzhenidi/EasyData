EasyData
========

EasyData is a lightweight framework that facilitates SQL data manipulation through object relational mapping. It is inspired by Rails' ActiveRecord, and, similarly to `ActiveRecord::Base`, it converts database tables into instances of the `SQLObject` class. EasyData secures against repeated database queries by storing relations on the instance.


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

* Call `#finalize!` at the end of your subclass definition, in order to have getter/setter methods defined


EasyData uses:
--------------

`activesupport`


Implementation Details:
-----------------------
* Uses `ActiveSupport` to infer the name of the table given the model,
use `::table_name=` to override the default.
* The associations methods provide default values for the options argument   

TODO:
-----
* Expand query interface to include `::includes` and `::joins`
* Make query methods lazy and stackable
* Include validations
