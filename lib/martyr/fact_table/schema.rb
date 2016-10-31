module Martyr
  class FactTable
    class Schema
      include FactTable::CoreEntityMethods
      include Dsl::BaseRecipe.module_define_recipe_methods(:all)

      attr_reader :core_entities, :folder_name
      attr_accessor :defaults_schema

      def initialize
        @core_entities = {}
        @folder_name = nil
      end

      def folder(folder_name)
        previous_folder = @folder_name
        @folder_name = [previous_folder, folder_name].compact.join('.')
        yield
      ensure
        @folder_name = previous_folder
      end

      private

      # @param id [String] core entity ID
      # @param options [Hash] hash of options to merge with defaults
      def options_with_defaults(id, options)
        return options unless defaults_schema
        defaults_schema.override_defaults(id, options)
      end

    end
  end
end
