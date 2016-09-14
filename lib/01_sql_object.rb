require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    return @columns if @columns
      cols = DBConnection.execute2(<<-SQL).first
        SELECT
          *
        FROM
          '#{table_name}'
      SQL

      cols.map!{|name| name.to_sym}
      @columns = cols
  end

  # the user of SQLObject will have to call finalize! at the end of
  # their subclass definition, in order to have getter/setter methods defined
  def self.finalize!
    columns.each do |col|
      define_method("#{col.to_s}=") do |val|
        attributes
        @attributes[col] = val
      end

      define_method(col) {
        attributes
        @attributes[col] }
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
        *
      FROM
        "#{table_name}"
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    results.map {|row| self.new(row)}
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        "#{table_name}"
      WHERE
        "id" = ?
    SQL
    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |k,v|
      k = k.to_sym
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k)
      self.send("#{k}=".to_sym, v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |col|
      send(col)
    end
  end

  def insert
    cols = self.class.columns[1..-1]
    col_names = cols.join(", ")
    question_marks = (["?"] * (cols.length   )).join(",")
    attributes = attribute_values[1..-1]

    DBConnection.execute(<<-SQL, *attributes)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns[1..-1]
    col_names = cols.map{ |col| "#{col}=?"}.join(", ")
    attributes = attribute_values[1..-1]
    attributes << self.id

    DBConnection.execute(<<-SQL, *attributes)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def save
    if self.id
      update
    else
      insert
    end
  end
end
