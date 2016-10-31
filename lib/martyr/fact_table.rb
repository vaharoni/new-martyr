module Martyr
  # This is the base class user classes are expected to inherit from
  class FactTable
    extend Martyr::Dsl::BaseRecipe.module_delegate_recipes_to_schema(:all)

    class << self
      delegate :folder, to: :schema_object
    end

    def self.schema_object
      @schema_object ||= FactTable::Schema.new
    end

    # @api
    def self.schema
      schema_object.core_entities
    end

    # @api
    def self.use_defaults(klass)
      schema_object.defaults_schema = klass.schema_object
    end

  end
end
