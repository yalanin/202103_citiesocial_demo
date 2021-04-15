require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '基本功能' do
    let(:cart) { Cart.new }

    it '商品丟進購物車' do
      cart.add_item(2)
      expect(cart.empty?).to be false
    end
  end
end
