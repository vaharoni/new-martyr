require 'spec_helper'

describe Martyr::Core::DefaultArgument do
  let(:subject_class) { Martyr::Core::DefaultArgument }

  describe 'unwrap' do
    subject { subject_class.new('value').unwrap }

    it 'returns the value wrapped by the default argument' do
      expect(subject).to eq('value')
    end
  end
end
