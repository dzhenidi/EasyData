require_relative 'db_connection'
require 'active_support/inflector'



class SQLObject

  def self.columns
    return @columns if @columns
      cols = DBConnection.execute2(<<-SQL).first
        SELECT
          *
        FROM
          #{table_name}
      SQL
      cols.map!(&:to_sym)
      @columns = cols
  end

  def self.finalize!
    columns.each do |name|
      define_method("#{name}=") do |name|
        self.attributes[name] = val
      end

      define_method(name) {
        self.attributes[name] }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |row| self.new(row) }
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=".to_sym, value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| send(attr) }
  end

  def insert
    columns = self.class.columns.drop(1)
    col_names = columns.join(", ")
    question_marks = (["?"] * (columns.length)).join(", ")
    attributes = attribute_values.drop(1)

    DBConnection.execute(<<-SQL, *attributes)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.drop(1)
    col_names = cols.map{ |col| "#{col}=?"}.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        #{self.class.table_name}.id = ?
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def save
    id.nil? ? insert : update
  end
end
