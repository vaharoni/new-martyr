require 'spec_helper'

describe Martyr::Defaults::CoreEntityMethods do
  let(:subject_class) { Martyr::Defaults::Schema }

  describe 'core entity methods' do
    subject { subject_class.new }

    Martyr::Core::BaseCoreEntity.all.each do |core_entity_class|
      it "stores the options when #{core_entity_class.entity_method} is called" do
        subject.send(core_entity_class.entity_method, 'some_id', k3: 'v3')
        expect(subject.core_entity_defaults).to eq('some_id' => { k3: 'v3' })
      end
    end
  end

end
