module Martyr
  class Defaults
    module CoreEntityMethods
      # Save the core entity defaults
      # @example
      #   def continuous_dimension(id, **options)
      #     @core_recipe_defaults[id] = options
      #   end
      #
      Core::BaseCoreEntity.all.each do |core_entity_class|
        define_method core_entity_class.entity_method do |id, **options|
          @core_entity_defaults[id] = options
        end
      end
    end
  end
end
