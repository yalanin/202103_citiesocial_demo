require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context 'validation' do
    describe 'title validate' do
      let(:vendor) { Vendor.new }

      it 'name can not be empty' do
        expect(vendor).not_to be_valid
      end
    end
  end

  context 'Scope Method' do
    describe '#available' do
      let!(:vendor1) { create(:vendor) }
      let!(:vendor2) { create(:vendor, online: false) }
      subject { Vendor.all }

      include_examples 'full scope'

      it 'online only' do
        expect(subject.available.size).to eq(1)
        expect(subject.available.map(&:online).uniq.size).to eq(1)
        expect(subject.available.map(&:online).uniq[0]).to be true
      end
    end
  end
end
