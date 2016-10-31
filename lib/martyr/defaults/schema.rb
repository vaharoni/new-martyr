module Martyr
  class Defaults
    class Schema
      include Defaults::CoreEntityMethods
      include Dsl::BaseRecipe.module_define_recipe_methods(:supporting_defaults)

      attr_reader :core_entity_defaults

      def initialize
        @core_entity_defaults = Hash.new({})
      end

      # @param id [String] core entity ID
      # @param options [Hash] hash of options to use as override over defaults
      def override_defaults(id, options)
        options_without_defaults = options.dup.delete_if{|_key, value| value.nil? or value.is_a?(Core::DefaultArgument)}
        core_entity_defaults[id].merge options_without_defaults
      end
    end
  end
end
