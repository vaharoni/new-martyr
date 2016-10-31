require 'spec_helper'

describe 'Functional specs' do
  describe 'Default options' do
    it 'takes the user option when use_default is not used' do
      expect(Fixtures::SimpleWiringWithoutDefaults.schema['without.default'].blank).to eq('(user-value)')
    end

    it 'takes the default option when use_defaults is used without override' do
      expect(Fixtures::SimpleWiringWithDefaults.schema['default.no_override'].blank).to eq('(default-value)')
    end

    it 'takes the user option when use_defaults is used with override' do
      expect(Fixtures::SimpleWiringWithDefaults.schema['default.override'].blank).to eq('(user-value)')
    end

    it 'takes the user option when use_defaults is used but does not define options for the entity ID' do
      expect(Fixtures::SimpleWiringWithDefaults.schema['default.not_defined'].blank).to eq('(user-value)')
    end
  end
end
