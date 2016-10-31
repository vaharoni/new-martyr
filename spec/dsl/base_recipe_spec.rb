require 'spec_helper'

describe Martyr::Dsl::BaseRecipe do
  let(:subject_class) { Martyr::Dsl::BaseRecipe }

  before do
    @no_supports_defaults_override = Class.new(subject_class) do
      def self.name; 'Martyr::Dsl::TestRecipe1'; end
    end

    @supports_defaults_override_true = Class.new(subject_class) do
      @supports_defaults = true
      def self.name; 'Martyr::Dsl::TestRecipe2'; end
    end

    @supports_defaults_override_false = Class.new(subject_class) do
      @supports_defaults = false
      def self.name; 'Martyr::Dsl::TestRecipe3'; end
    end
  end

  describe '::recipes and ::all' do
    it 'returns all classes' do
      expect(subject_class.recipes).to include(@no_supports_defaults_override, @supports_defaults_override_true,
        @supports_defaults_override_false)
    end
  end

  describe '::recipes_supporting_defaults' do
    it 'only returns classes supporting defaults' do
      expect(subject_class.recipes_supporting_defaults).to include(@no_supports_defaults_override,
        @supports_defaults_override_true)

      expect(subject_class.recipes_supporting_defaults).not_to include(@supports_defaults_override_false)
    end
  end

  describe '::supports_defaults?' do
    it 'returns true when @supports_default is not defined' do
      expect(@no_supports_defaults_override.supports_defaults?).to eq(true)
    end

    it 'returns true when @supports_default is set to true' do
      expect(@supports_defaults_override_true.supports_defaults?).to eq(true)
    end

    it 'returns false when @supports_default is set to false' do
      expect(@supports_defaults_override_false.supports_defaults?).to eq(false)
    end
  end

  describe '::recipe_method' do
    it 'returns the underscore version of the last class name' do
      expect(@no_supports_defaults_override.recipe_method).to eq('test_recipe1')
    end
  end

  describe '::module_define_recipe_methods' do
    before do
      # We must clear module memoization since our classes are re-generated for every `it` block
      Martyr::Dsl::BaseRecipe.instance_variable_set(:@_module_define_recipe_methods, {})
    end

    context 'scope is :all' do
      subject { Class.new { extend Martyr::Dsl::BaseRecipe.module_define_recipe_methods(:all) } }

      it 'correctly defines test_recipe1 in the module' do
        expect_any_instance_of(@no_supports_defaults_override).to receive(:register).with('arg')
        subject.test_recipe1('arg')
      end

      it 'correctly defines test_recipe2 in the module' do
        expect_any_instance_of(@supports_defaults_override_true).to receive(:register).with('arg')
        subject.test_recipe2('arg')
      end

      it 'correctly defines test_recipe3 in the module' do
        expect_any_instance_of(@supports_defaults_override_false).to receive(:register).with('arg')
        subject.test_recipe3('arg')
      end
    end

    context 'scope is :supporting_defaults' do
      subject { Class.new { extend Martyr::Dsl::BaseRecipe.module_define_recipe_methods(:supporting_defaults) } }

      it 'correctly defines test_recipe1 in the module' do
        expect_any_instance_of(@no_supports_defaults_override).to receive(:register).with('arg')
        subject.test_recipe1('arg')
      end

      it 'correctly defines test_recipe2 in the module' do
        expect_any_instance_of(@supports_defaults_override_true).to receive(:register).with('arg')
        subject.test_recipe2('arg')
      end

      it 'correctly does not define test_recipe3 in the module' do
        expect(subject.respond_to?(:test_recipe3)).to eq(false)
      end
    end
  end

  describe '::module_delegate_recipes_to_schema' do
    before do
      # We must clear module memoization since our classes are re-generated for every `it` block
      Martyr::Dsl::BaseRecipe.instance_variable_set(:@_module_delegate_recipes_to_schema, {})
    end

    context 'scope is :all' do
      subject { Class.new { extend Martyr::Dsl::BaseRecipe.module_delegate_recipes_to_schema(:all) } }
      let(:schema_double) { double 'Schema' }

      before do
        expect(subject).to receive(:schema_object).and_return(schema_double)
      end

      it 'correctly delegates test_recipe1 to the schema object' do
        expect(schema_double).to receive(:test_recipe1).with('arg')
        subject.test_recipe1('arg')
      end

      it 'correctly delegates test_recipe2 to the schema object' do
        expect(schema_double).to receive(:test_recipe2).with('arg')
        subject.test_recipe2('arg')
      end

      it 'correctly delegates test_recipe3 to the schema object' do
        expect(schema_double).to receive(:test_recipe3).with('arg')
        subject.test_recipe3('arg')
      end
    end

    context 'scope is :supporting_defaults' do
      subject { Class.new { extend Martyr::Dsl::BaseRecipe.module_delegate_recipes_to_schema(:supporting_defaults) } }
      let(:schema_double) { double 'Schema' }

      it 'correctly delegates test_recipe1 to the schema object' do
        expect(subject).to receive(:schema_object).and_return(schema_double)
        expect(schema_double).to receive(:test_recipe1).with('arg')
        subject.test_recipe1('arg')
      end

      it 'correctly delegates test_recipe2 to the schema object' do
        expect(subject).to receive(:schema_object).and_return(schema_double)
        expect(schema_double).to receive(:test_recipe2).with('arg')
        subject.test_recipe2('arg')
      end

      it 'correctly does not delegate test_recipe3 to the schema object' do
        expect(subject.respond_to?(:test_recipe3)).to eq(false)
      end
    end
  end

  describe 'as_default' do
    let(:schema) { double('Schema') }

    it 'wraps the value with DefaultArgument' do
      expect(Martyr::Core::DefaultArgument).to receive(:new).with('value')
      subject_class.new(schema).as_default('value')
    end
  end

end
