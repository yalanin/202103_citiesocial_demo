require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '基本功能' do
    let(:cart) { Cart.new }
    # let(:vendor) { FactoryBot.build(:vendor) }
    # let(:category) { FactoryBot.build(:category) }
    let(:product) { create(:product) }
    let(:product1) { create(:product, sell_price: 5) }
    let(:product2) { create(:product, sell_price: 10) }

    it '商品丟進購物車' do
      cart.add_item(2)
      expect(cart.empty?).to be false
    end

    it '相同商品增加數量、不增加項目' do
      3.times { cart.add_item(1) }
      2.times { cart.add_item(2) }
      expect(cart.items.count).to eq(2)
      expect(cart.items.first.quantity).to eq(3)
    end

    it '可從購物車拿出商品' do
      cart.add_item(product.id)
      expect(cart.items.first.product).to be_a Product
    end

    it '計算總金額' do
      3.times { cart.add_item(product1.id) }
      2.times { cart.add_item(product2.id) }
      expect(cart.total_price).to eq(35)
    end
  end

  describe '進階功能' do
  end
end
