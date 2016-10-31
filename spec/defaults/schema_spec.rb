require 'spec_helper'

describe Martyr::Defaults::Schema do
  let(:subject_class) { Martyr::Defaults::Schema }

  describe 'recipe methods' do
    subject { subject_class.new }

    Martyr::Dsl::BaseRecipe.recipes_supporting_defaults.each do |recipe_class|
      it "registers the recipe when #{recipe_class.recipe_method} is invoked" do
        expect_any_instance_of(recipe_class).to receive(:register).with(:arg1, :arg2, :arg3)
        subject.send(recipe_class.recipe_method, :arg1, :arg2, :arg3)
      end
    end
  end

  describe '#override_defaults' do
    let(:object) { subject_class.new }
    let(:options) { { k1: 'override' } }
    subject { object.override_defaults('id', options) }

    context 'no defaults' do
      it 'returns the options' do
        expect(subject).to eq(k1: 'override')
      end
    end

    context 'with defaults' do
      before do
        object.core_entity_defaults['id'] = { blank: '---' }
      end

      context 'no overlapping options' do
        it 'returns the options together with the defaults' do
          expect(subject).to eq(k1: 'override', blank: '---')
        end
      end

      context 'overlapping options that are nil' do
        let(:options) { { blank: nil } }

        it 'returns the default value' do
          expect(subject).to eq(blank: '---')
        end
      end

      context 'overlapping options that are Core::DefaultArgument' do
        let(:options) { { blank: Martyr::Core::DefaultArgument.new('(blank)') } }

        it 'returns the default value' do
          expect(subject).to eq(blank: '---')
        end
      end

      context 'overlapping options that are a value' do
        let(:options) { { blank: '(blank)' } }

        it 'returns the provided option value' do
          expect(subject).to eq(blank: '(blank)')
        end
      end
    end
  end
end
