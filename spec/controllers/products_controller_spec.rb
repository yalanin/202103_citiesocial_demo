require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product) { create(:product, :with_skus, sell_price: 3, on_sell: true) }
  let!(:product1) { create(:product, :with_skus, sell_price: 2) }

  describe '#index' do
    it 'should return products which on_sell is true' do
      get :index
      expect(assigns(:products).size).to eq(1)
      expect(assigns(:products).ids[0]).to eq(product.id)
    end
  end

  describe '#show' do
    it 'should return product which id is matched request' do
      get :show, params: { id: product1.id }
      expect(assigns(:product).id).to eq(product1.id)
      expect(assigns(:product).skus.ids).to eq(product1.skus.ids)
    end
  end
end