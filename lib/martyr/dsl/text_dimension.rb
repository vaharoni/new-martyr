module Martyr
  module Dsl
    class TextDimension < BaseRecipe

      # @example
      #   register('author.name')
      #   register('post.created_at_month', value: year_month('posts.created_at'))
      def register(id, value: nil, blank: nil, sort: nil, format: nil)
        value ||= id
        blank ||= as_default('---')
        schema.string_dimension(id, value: value, blank: blank, sort: sort, format: format)
      end

    end
  end
end
