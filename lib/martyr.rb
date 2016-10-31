require 'martyr/version'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'

module Martyr
  extend ActiveSupport::Autoload

  module Core
    extend ActiveSupport::Autoload

    autoload :BaseCoreEntity
    autoload :DefaultArgument

    eager_autoload do
      autoload :ContinuousDimension
      autoload :ModelDimension
      autoload :StringDimension
    end
  end
  Core.eager_load!

  module Dsl
    extend ActiveSupport::Autoload

    autoload :BaseRecipe

    eager_autoload do
      autoload :BooleanDimension
      autoload :CountMetric
      autoload :DateDimension
      autoload :DateDimensionGroup
      autoload :MaxMetric
      autoload :MinMetric
      autoload :NumericDimension
      autoload :Query
      autoload :RecordDimension
      autoload :SubQuery
      autoload :SumMetric
      autoload :TextDimension
      autoload :TimeDimension
      autoload :TimeDimensionGroup
    end
  end
  Dsl.eager_load!

  autoload :Defaults
  autoload :FactTable

  class FactTable
    extend ActiveSupport::Autoload

    autoload :Schema
    autoload :CoreEntityMethods
  end

  class Defaults
    extend ActiveSupport::Autoload

    autoload :Schema
    autoload :CoreEntityMethods
  end
end


