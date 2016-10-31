module Martyr
  module Dsl
    class BooleanDimension < BaseRecipe

      # @option true [String] String to display if the value is evaluated to true. Default is 'Yes'.
      # @option true [String] String to display if the value is evaluated to false. Default is 'No'.
      def register(id, value: nil, **options)
        # true_label = options[:true]
        # false_label = options[:false]
      end

    end
  end
end
