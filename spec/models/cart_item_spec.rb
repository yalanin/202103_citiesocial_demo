require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { Cart.new }
  let(:product1) { create(:product, :with_skus, sell_price: 5) }
  let(:product2) { create(:product, :with_skus, sell_price: 10) }

  it '增加商品數量' do
    cart.add_sku(product1.id, 2, product1.skus.first.id)
    expect(cart.items[0].quantity).to eq(2)
    cart.items[0].increment!(5)
    expect(cart.items[0].quantity).to eq(7)
  end

  it '檢查商品 id' do
    cart.add_sku(product1.id, 1, product1.skus.first.id)
    expect(cart.items[0].product_id).to eq(1)
  end

  it '計算購物車金額' do
    3.times { cart.add_sku(product1.id, 1, product1.skus.first.id) }
    2.times { cart.add_sku(product2.id, 1, product2.skus.first.id) }

    expect(cart.items.first.total_price.to_i).to eq(15)
    expect(cart.items.last.total_price.to_i).to eq(20)
  end
end
