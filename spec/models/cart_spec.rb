require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { Cart.new }
  let(:cart_with_items) { Cart.new(random_cart_hash) }
  # let(:vendor) { FactoryBot.build(:vendor) }
  # let(:category) { FactoryBot.build(:category) }
  let(:product) { create(:product, :with_skus) }
  let(:product1) { create(:product, :with_skus, sell_price: 5) }
  let(:product2) { create(:product, :with_skus, sell_price: 10) }

  context 'Instance Method' do
    describe '基本功能' do
      it '檢測購物車是否為空' do
        expect(cart.items).to be_empty
        expect(cart_with_items.items).not_to be_empty
      end

      it '商品丟進購物車' do
        cart.add_sku(2, 1)
        expect(cart).not_to be_empty
      end

      it '相同商品增加數量、不增加項目' do
        3.times { cart.add_sku(1, 1) }
        2.times { cart.add_sku(2, 1) }
        expect(cart.items.count).to eq(2)
        expect(cart.items.first.quantity).to eq(3)
      end

      it '可從購物車拿出商品' do
        cart.add_sku(product.id, 1, product.skus.first.id)
        expect(cart.items.first.product).to be_a Product
      end

      it '計算總金額' do
        3.times { cart.add_sku(product1.id, 1, product1.skus.first.id) }
        2.times { cart.add_sku(product2.id, 1, product2.skus.first.id) }
        expect(cart.total_price).to eq(35)
      end
    end
  end

  context 'Class Method' do
    describe '進階功能' do
      it '新增空購物車' do
        reduction = Cart.from_hash
        expect(reduction.items.size).to eq(0)
      end

      it '將購物車功能存入 session' do
        3.times { cart.add_sku(product1.id, 1, 1) }
        2.times { cart.add_sku(product2.id, 1, 3) }

        expect(cart.serialize).to eq cart_hash
      end

      it '將購物車內容存入 session，同時可以還原回購物車' do
        reduction = Cart.from_hash(cart_hash)

        expect(reduction.items.first.quantity).to be(3)
      end
    end
  end

  private

  def cart_hash
    {
      'items' => [
        { 'product_id' => 1, 'quantity' => 3, 'sku_id' => 1 },
        { 'product_id' => 2, 'quantity' => 2, 'sku_id' => 3 }
      ]
    }
  end

  def random_cart_hash
    cart_item = { 'product_id' => [*1..20].sample, 'quantity' => [*1..3].sample, 'sku_id' => [*1..20].sample }
    { 'items' => [cart_item] * [*1..5].sample }
  end
end
