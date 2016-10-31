require 'spec_helper'

describe Martyr::FactTable do
  let(:subject_class) { Martyr::FactTable }

  describe '::schema_objects' do
    subject { subject_class.schema_object }

    it 'returns the right schema object' do
      expect(subject).to be_a(Martyr::FactTable::Schema)
    end
  end

  describe '::schema' do
    subject { subject_class.schema }

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end
  end

  describe 'recipe methods' do
    Martyr::Dsl::BaseRecipe.all.each do |recipe_class|
      it "delegates #{recipe_class.recipe_method} to the schema" do
        expect(subject_class.schema_object).to receive(recipe_class.recipe_method)
        subject_class.send(recipe_class.recipe_method)
      end
    end
  end

  describe '::use_defaults' do
    let(:defaults_class) { double('Defaults class') }
    let(:defaults_schema) { double('Defaults schema') }
    subject { subject_class.use_defaults defaults_class }

    before do
      allow(defaults_class).to receive(:schema_object).and_return(defaults_schema)
    end

    it 'sets defaults_schema appropriately' do
      subject
      expect(subject_class.schema_object.defaults_schema).to eq(defaults_schema)
    end
  end
end
