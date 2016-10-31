require 'spec_helper'

describe Martyr::FactTable::CoreEntityMethods do
  let(:subject_class) { Martyr::FactTable::Schema }

  describe 'core entity methods' do
    subject { subject_class.new }

    before do
      allow(subject).to receive(:options_with_defaults).and_return(k1: 'v1', k2: 'v2')
    end

    Martyr::Core::BaseCoreEntity.all.each do |core_entity_class|
      it "builds a core entity when #{core_entity_class.entity_method} is called" do
        expect_any_instance_of(core_entity_class).to receive(:set_options).with(k1: 'v1', k2: 'v2')
        subject.send(core_entity_class.entity_method, 'some_id', k3: 'v3')
      end
    end
  end

end
