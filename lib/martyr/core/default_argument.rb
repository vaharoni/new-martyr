module Martyr
  module Core

    # This class is used to wrap any value so that a DSL recipe can denote it as default.
    # To see why this matters, imagine the following DSL recipe:
    #
    #   class Martyr::Dsl::CustomRecipe
    #     def register(id, blank: nil)
    #       blank ||= '---'
    #       schema.string_dimension(id, blank: blank)
    #     end
    #   end
    #
    # Now, imagine the user has the following classes:
    #
    #   class DimensionBus < Martyr::Defaults
    #     custom_recipe 'author.name', blank: '(no author)'
    #   end
    #
    #   class MyFactTable < Martyr::FactTable
    #     use_defaults DimensionBus
    #     custom_recipe 'author.name'
    #   end
    #
    # The user expects the `blank` option of the created string dimension to be '(no author)'.
    # However:
    # - The Defaults::Schema stores the options for the core entity as '(no author)'
    # - The FactTable::Schema stores the options for the core entity as '---'
    # - When the options from the fact table schema are merged with the options for the defaults schema, '---' takes
    #   precedence since it is not `nil`. There is no way to know whether '---' was entered by the user or as a
    #   default by `CustomRecipe`.
    #
    # To solve this, here is the correct implementation of `CustomRecipe`:
    #
    #   class Martyr::Dsl::CustomRecipe
    #     def register(id, blank: nil)
    #       blank ||= as_default('---')
    #       schema.string_dimension(id, blank: blank)
    #     end
    #   end
    #
    # Using `as_default` wraps the value with the `DefaultArgument` class, allowing Martyr to ignore it when
    # merging options in the fact table schema with options in the defaults schema.
    #
    class DefaultArgument

      attr_reader :value
      alias_method :unwrap, :value

      def initialize(value)
        @value = value
      end
    end
  end
end

