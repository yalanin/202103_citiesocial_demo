require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:product) { create(:product, :with_skus, sell_price: 3) }
  let(:order_item) { create(:order_item, product: product, quantity: 12) }

  it '計算單項商品金額' do
    expect(order_item.total_price).to eq(36)
  end
end