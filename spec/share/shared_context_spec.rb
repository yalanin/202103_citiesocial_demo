RSpec.shared_context 'share order' do
  let(:product) { create(:product, :with_skus, sell_price: 15) }
  let(:order1) { create(:order, :with_order_items, product: product) }
end