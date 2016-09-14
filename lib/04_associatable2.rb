require_relative '03_associatable'

# Phase IV
module Associatable

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name] 

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      foreign_key = through_name.to_s + "_id"
      results = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        SELECT
          "#{source_options.table_name}".*
        FROM
         "#{through_options.table_name}"
        JOIN
          "#{source_options.table_name}"
        ON
          "#{through_options.table_name}"."#{source_options.foreign_key}" = "#{source_options.table_name}".id
        WHERE
          "#{source_options.table_name}".id = ?
      SQL
      results.map {|row| source_options.model_class.new(row)}.first
    end
  end
end
