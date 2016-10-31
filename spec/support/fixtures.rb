module Fixtures

  class SimpleWiringWithoutDefaults < Martyr::FactTable
    text_dimension 'without.default', blank: '(user-value)'
  end

  class SimpleWiringDefaults < Martyr::Defaults
    text_dimension 'default.no_override', blank: '(default-value)'
    text_dimension 'default.override', blank: '(default-value)'
  end

  class SimpleWiringWithDefaults < Martyr::FactTable
    use_defaults SimpleWiringDefaults

    text_dimension 'default.no_override'
    text_dimension 'default.override', blank: '(user-value)'
    text_dimension 'default.not_defined', blank: '(user-value)'
  end
end
