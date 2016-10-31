module Martyr
  class FactTable
    module CoreEntityMethods
      # Register the core entity methods
      # @example
      #   def continuous_dimension(id, **options)
      #     @core_recipes[id] = Core::ContinuousDimension.new(id).register(**options_with_defaults(id, options))
      #   end
      #
      Core::BaseCoreEntity.all.each do |core_entity_class|
        define_method core_entity_class.entity_method do |id, **options|
          @core_entities[id] = core_entity_class.new(id).set_options(**options_with_defaults(id, options))
        end
      end
    end
  end
end
