module Martyr
  module Core
    class BaseCoreEntity
      mattr_accessor :entities
      self.entities = []

      class << self
        alias_method :all, :entities
      end

      def self.inherited(klass)
        entities << klass
      end

      # @return [String] the name of the method that invokes registration of the recipe.
      #   By default it is the last part of the class name.
      #   Recipes may override this method to change the recipe method name.
      # @example
      #   Martyr::Recipe::TextDimension.recipe_method
      #   # => 'text_dimension'
      def self.entity_method
        name.split('::').last.underscore
      end

      attr_reader :id

      def initialize(id)
        @id = id
      end

      # @param **options [Hash] hash of options that initialized the core recipe's attributes
      # @return [self]
      def set_options(**options)
        options.each do |key, value|
          value = value.unwrap if value.is_a?(DefaultArgument)
          send("#{key}=", value)
        end
        self
      end
    end
  end
end
