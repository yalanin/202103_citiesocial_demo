require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'scope test' do
    let!(:product1) { create(:product) }
    let!(:product2) { create(:product, on_sell: true) }
    subject { Product.all }

    it '全部範圍' do
      expect(subject.size).to eq(2)
    end

    it 'on sell only' do
      expect(subject.on_sell.size).to eq(1)
      expect(subject.on_sell.map(&:on_sell).uniq.size).to eq(1)
      expect(subject.on_sell.map(&:on_sell).uniq[0]).to be true
    end
  end
end