require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '基本功能' do
    let(:cart) { Cart.new }
    let(:vendor) { Vendor.create(title: 'vendor_spec') }
    let(:product) { Product.create(name: 'product_1', list_price: '100', sell_price: '50', vendor_id: vendor.id) }

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
  end

  describe '進階功能' do
  end
end
