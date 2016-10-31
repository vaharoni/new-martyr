module Martyr
  # This is a class the user code can derive from
  class Defaults
    extend Dsl::BaseRecipe.module_delegate_recipes_to_schema(:supporting_defaults)

    def self.schema_object
      @schema_object ||= Defaults::Schema.new
    end

    # @api
    def self.schema
      schema_object.core_entity_defaults
    end
  end
end
