require 'spec_helper'

describe Martyr::Core::BaseCoreEntity do
  let(:subject_class) { Martyr::Core::BaseCoreEntity }

  before do
    @klass = Class.new(subject_class) do
      attr_accessor :option1, :option2

      def self.name
        'Martyr::Core::TestEntity'
      end
    end
  end

  describe '::entities and ::all' do
    it 'registers classes that inherit from the base class' do
      expect(subject_class.entities).to include(@klass)
      expect(subject_class.all).to include(@klass)
    end
  end

  describe '::entity_method' do
    subject { @klass.entity_method }

    it 'returns the underscore version of the last class name' do
      expect(subject).to eq('test_entity')
    end
  end

  describe '::set_options' do
    let(:object) { @klass.new('id') }
    subject { object.set_options(**options) }

    context 'values do not contain DefaultArgument' do
      let(:options) { { option1: 'value1', option2: 'value2' } }

      it 'assigns attribute accessors' do
        subject
        expect(object.option1).to eq('value1')
        expect(object.option2).to eq('value2')
      end
    end

    context 'values contain DefaultArgument' do
      let(:default_arg) { Martyr::Core::DefaultArgument.new('value2') }
      let(:options) { { option1: 'value1', option2: default_arg } }

      it 'assigns attribute accessors by unwrapping the default argument' do
        expect(default_arg).to receive(:unwrap).and_return('value2')
        subject
        expect(object.option1).to eq('value1')
        expect(object.option2).to eq('value2')
      end
    end
  end

end
