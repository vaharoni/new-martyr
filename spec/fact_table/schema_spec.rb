require 'spec_helper'

describe Martyr::FactTable::Schema do
  let(:subject_class) { Martyr::FactTable::Schema }
  let(:object) { subject_class.new }

  describe 'recipe methods' do
    subject { object }

    Martyr::Dsl::BaseRecipe.all.each do |recipe_class|
      it "registers the recipe when #{recipe_class.recipe_method} is invoked" do
        expect_any_instance_of(recipe_class).to receive(:register).with(:arg1, :arg2, :arg3)
        subject.send(recipe_class.recipe_method, :arg1, :arg2, :arg3)
      end
    end
  end

  # Tested even though private, as it is stubbed in CoreEntityMethods
  describe '#options_with_defaults' do
    subject { object.send(:options_with_defaults, 'id', k1: 'v1', k2: 'v2') }

    context 'no defaults schema' do
      it 'returns options' do
        expect(subject).to eq(k1: 'v1', k2: 'v2')
      end
    end

    context 'defaults schema is used' do
      let(:defaults_double) { double 'Defaults double' }

      before do
        object.defaults_schema = defaults_double
      end

      it 'call override_defaults' do
        expect(defaults_double).to receive(:override_defaults).with('id', k1: 'v1', k2: 'v2')
        subject
      end
    end
  end

  describe '#folder and #folder_name' do
    it 'handles folder setting and resetting correctly for main and sub folders' do
      expect(object.folder_name).to eq(nil)
      object.folder('main') do
        expect(object.folder_name).to eq('main')
        object.folder('sub') do
          expect(object.folder_name).to eq('main.sub')
        end
        expect(object.folder_name).to eq('main')
      end
      expect(object.folder_name).to eq(nil)
    end

    it 'resets the folder if the user code has an error' do
      expect(object.folder_name).to eq(nil)
      object.folder('main') do
        begin
          expect(object.folder_name).to eq('main')
          object.folder('sub') do
            expect(object.folder_name).to eq('main.sub')
            raise 'err'
          end
        rescue
          expect(object.folder_name).to eq('main')
        end
      end
      expect(object.folder_name).to eq(nil)
    end
  end

end
