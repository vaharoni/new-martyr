require 'spec_helper'

describe Martyr::Defaults do
  let(:subject_class) { Martyr::Defaults }

  describe '::schema_objects' do
    subject { subject_class.schema_object }

    it 'returns the right schema object' do
      expect(subject).to be_a(Martyr::Defaults::Schema)
    end
  end

  describe '::schema' do
    subject { subject_class.schema }

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end
  end

  describe 'recipe methods' do
    Martyr::Dsl::BaseRecipe.recipes_supporting_defaults.each do |recipe_class|
      it "delegates #{recipe_class.recipe_method} to the schema" do
        expect(subject_class.schema_object).to receive(recipe_class.recipe_method)
        subject_class.send(recipe_class.recipe_method)
      end
    end
  end
end
