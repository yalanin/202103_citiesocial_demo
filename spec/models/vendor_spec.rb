require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'validation' do
    let(:vendor) { Vendor.new }

    it 'name can not be empty' do
      expect(vendor).not_to be_valid
    end
  end

  describe 'scope test' do
    let!(:vendor1) { create(:vendor) }
    let!(:vendor2) { create(:vendor, online: false) }
    subject { Vendor.all }

    it '全部範圍' do
      expect(subject.size).to eq(2)
    end

    it 'online only' do
      expect(subject.available.size).to eq(1)
      expect(subject.available.map(&:online).uniq.size).to eq(1)
      expect(subject.available.map(&:online).uniq[0]).to be true
    end
  end
end
