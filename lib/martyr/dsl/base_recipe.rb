module Martyr
  module Dsl
    class BaseRecipe
      @_module_define_recipe_methods = {}
      @_module_delegate_recipes_to_schema = {}

      mattr_accessor :recipes
      self.recipes = []

      def self.inherited(klass)
        recipes << klass
      end

      def self.recipes_supporting_defaults
        recipes.select(&:supports_defaults?)
      end

      class << self
        alias_method :all, :recipes
      end

      # Builds a module that has a method per recipe which builds a recipe instance and registers it with the provided
      # options via the instance's #register method.
      # This module is included into one of the schema objects, e.g. FactTable::Schema.
      #
      #   @example for TextDimension:
      #
      #     def text_dimension(*args)
      #       Recipe::TextDimension.new(self).register(*args)
      #     end
      #
      # @param scope [:all, :supporting_defaults]
      # @return [Module]
      #
      def self.module_define_recipe_methods(scope)
        return @_module_define_recipe_methods[scope] if @_module_define_recipe_methods[scope]

        relevant_recipes = recipes_for_scope(scope)
        @_module_define_recipe_methods[scope] = Module.new do
          relevant_recipes.each do |klass|
            define_method klass.recipe_method do |*args|
              klass.new(self).register(*args)
            end
          end
        end
      end

      # Builds a module that has a method per recipe which delegates to `schema_object`.
      # This module is included into one of the core user facing classes, e.g. Martyr::FactTable.
      #
      #   @example for TextDimension:
      #
      #     def text_dimension(*args)
      #       schema_object.text_dimension(*args)
      #     end
      #
      # @param scope [:all, :supporting_defaults]
      # @return [Module]
      #
      def self.module_delegate_recipes_to_schema(scope)
        return @_module_delegate_recipes_to_schema[scope] if @_module_delegate_recipes_to_schema[scope]

        relevant_recipes = recipes_for_scope(scope)
        @_module_delegate_recipes_to_schema[scope] = Module.new do
          relevant_recipes.each do |klass|
            define_method klass.recipe_method do |*args|
              schema_object.send(klass.recipe_method, *args)
            end
          end
        end
      end

      # @return [String] the name of the method that invokes registration of the recipe.
      #   By default it is the last part of the class name.
      #   Recipes may override this method to change the recipe method name.
      # @example
      #   Martyr::Recipe::TextDimension.recipe_method
      #   # => 'text_dimension'
      def self.recipe_method
        name.split('::').last.underscore
      end

      # @return [Boolean] whether the concrete class is flagged to support default using the ivar @supports_defaults.
      #   Returns true if the ivar is not defined.
      def self.supports_defaults?
        @supports_defaults.nil? or @supports_defaults
      end

      attr_reader :schema

      # @param schema [Schema::Defaults, Schema::FactTable]
      def initialize(schema)
        @schema = schema
      end

      # Concrete classes must implement.
      # The concrete class responsibility is to address all the necessary variants to store whatever information it
      # needs, and then call one of the core recipes, e.g. `schema.continuous_dimension`.
      #
      def register(*args)
        raise NotImplementedError
      end

      # @see note in Core::DefaultArgument
      def as_default(value)
        Core::DefaultArgument.new(value)
      end

      # @param scope [:all, :supporting_defaults]
      # @return [Array<BaseRecipe>] recipe classes that match the given scope
      def self.recipes_for_scope(scope)
        case scope
          when :all
            all
          when :supporting_defaults
            recipes_supporting_defaults
          else
            raise "Internal Error: invalid scope `#{scope}` for recipes_for_scope"
        end
      end
      private_class_method :recipes_for_scope
    end
  end
end
