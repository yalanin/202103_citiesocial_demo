require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  login_user

  describe '#index' do
    let!(:product) { create(:product, :with_skus, sell_price: 3, on_sell: true) }
    let!(:product1) { create(:product, :with_skus, sell_price: 2) }

    it 'should return all products' do
      get :index
      expect(assigns(:products).size).to eq(2)
    end
  end

  describe '#new' do
    it 'should create new product' do
      get :new
      expect(assigns(:product)).to be_a Product
      expect(assigns(:product).id).to be nil
      expect(assigns(:product).skus.ids).to be_empty
    end
  end

  describe '#create' do
    let!(:vendor) { create(:vendor) }
    it 'should redirect_to admin_products_path' do
      post :create, params: { product: { name: 'create prodoct', list_price: 10, sell_price: 5, vendor_id: vendor.id } }
      expect(flash[:notice]).to eq('商品已新增')
      expect(response).to redirect_to('/admin/products')
    end

    it 'should render new_admin_products_path' do
      post :create, params: { product: { name: 'create prodoct', list_price: 10, sell_price: -5 }}
      expect(flash[:error]).not_to be_empty
      expect(response).to redirect_to('/admin/products/new')
    end
  end

  describe '#update' do
    let!(:product) { create(:product, :with_skus, sell_price: 3, on_sell: true) }
    it 'should update product success' do
      patch :update, params: { id: 1, product: { on_sell: false } }
      expect(flash[:notice]).to eq('商品已更新')
      expect(response).to redirect_to("/admin/products/#{product.code}/edit")
    end

    it 'should not update product' do
      patch :update, params: { id: 1, product: { list_price: -1 } }
      expect(flash[:error]).not_to be_empty
      expect(response).to redirect_to("/admin/products/#{product.code}/edit")
    end
  end

  describe '#destroy' do
    let!(:product) { create(:product, sell_price: 3, on_sell: true) }
    it 'should destroy product success' do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to eq('商品已刪除')
      expect(response).to redirect_to("/admin/products")
    end
  end
end