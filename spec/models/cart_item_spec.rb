require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { Cart.new }
  let(:product1) { create(:product, sell_price: 5) }
  let(:product2) { create(:product, sell_price: 10) }

  it '計算購物車金額' do
    3.times { cart.add_item(product1.id) }
    2.times { cart.add_item(product2.id) }

    expect(cart.items.first.total_price).to eq(15)
    expect(cart.items.last.total_price).to eq(20)
  end
end
