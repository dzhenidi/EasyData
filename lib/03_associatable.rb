require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.to_s.constantize
  end

  def table_name
    @class_name.to_s.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    name_id = (name.to_s + "_id").to_sym
    defaults = { :foreign_key => name_id, :primary_key => :id, :class_name => name.to_s.camelcase}
    options = defaults.merge(options)
    @foreign_key, @class_name, @primary_key = options[:foreign_key], options[:class_name], options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    cn = name.to_s[0...-1].camelcase
    fk = (self_class_name.downcase + "_id").to_sym
    defaults = { :foreign_key => fk, :primary_key => :id, :class_name => cn}
    options = defaults.merge(options)
    # debugger
    @foreign_key, @class_name, @primary_key = options[:foreign_key], options[:class_name], options[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method do
      foreign_key_value = self.send(options[:foreign_key])
      target_model_class = model_class
      where(:primary_key => @foreign_key)
    end
  end

  def has_many(name, options = {})

    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  include Associatable
end
