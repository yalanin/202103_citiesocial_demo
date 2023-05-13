require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { Cart.new }
  let(:product) { create(:product, :with_skus, sell_price: 3) }
  let(:order_item) { create(:order_item, product: product, quantity: 12) }
  let(:order) { create(:order, :with_order_items, product: product, user: user) }
  let(:order1) { create(:order, :with_order_items, product: product, user: user, state: 'paid') }
  before do
    cart.add_sku(product.id, 2, product.skus.first.id)
    controller.session[:cart_9876] = cart.serialize
    allow(controller).to receive(:current_user) { user }
  end
  login_user

  describe '#index' do
    it '顯示清單' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
    it '導向付款頁面' do
      allow_any_instance_of(LinePayService).to receive(:payment_url).and_return('https://linepay_url')
      allow_any_instance_of(LinePayService).to receive(:pay_now).and_return(true)
      post :create, params: { order: { recipient: order.recipient, tel: order.tel, address: order.address, note: '' } }
      expect(response).to redirect_to('https://linepay_url')
    end

    it '建立付款頁面失敗' do
      allow_any_instance_of(LinePayService).to receive(:pay_now).and_return(false)
      post :create, params: { order: { recipient: order.recipient, tel: order.tel, address: order.address, note: '' } }
      expect(response).to redirect_to(checkout_cart_path)
    end

    it '建立訂單失敗' do
      post :create, params: { order: { recipient: '', tel: '', address: '', note: '' } }
      expect(response).to render_template('carts/checkout')
    end
  end

  describe '#confirm' do
    it '付款完成' do
      allow_any_instance_of(LinePayService).to receive(:confirm).and_return(true)
      allow_any_instance_of(LinePayService).to receive(:order_id) { order.order_number }
      allow_any_instance_of(LinePayService).to receive(:transaction_id) { order.transaction_id }
      allow_any_instance_of(LinePayService).to receive(:pay).and_return('https://pay_url.com')
      get :confirm
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('付款完成')
    end

    it '付款失敗' do
      allow_any_instance_of(LinePayService).to receive(:confirm).and_return(false)
      allow_any_instance_of(LinePayService).to receive(:code) { '999' }
      allow_any_instance_of(LinePayService).to receive(:messages) { 'something wrong' }
      get :confirm
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('發生錯誤，錯誤訊息：999 something wrong')
    end
  end

  describe '#cancel' do
    it '付款完成取消付款成功' do
      allow_any_instance_of(LinePayService).to receive(:cancel).and_return(true)
      delete :cancel, params: { id: order1.id }
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq("訂單 #{order1.order_number} 已取消")
    end

    it '付款完成取消付款失敗' do
      allow_any_instance_of(LinePayService).to receive(:cancel).and_return(false)
      allow_any_instance_of(LinePayService).to receive(:messages) { 'something wrong' }
      delete :cancel, params: { id: order1.id }
      expect(response).to redirect_to(orders_path)
      expect(flash[:alert]).to eq('something wrong')
    end

    it '未付款取消成功' do
      delete :cancel, params: { id: order.id }
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq("訂單 #{order.order_number} 已取消")
    end
  end

  describe '#pay' do
    it '付款成功' do
      allow_any_instance_of(LinePayService).to receive(:pay).and_return(true)
      allow_any_instance_of(LinePayService).to receive(:payment_url) { 'https://linepay_url' }
      post :pay, params: { id: order.id }
      expect(response).to redirect_to('https://linepay_url')
    end

    it '付款失敗' do
      allow_any_instance_of(LinePayService).to receive(:pay).and_return(false)
      allow_any_instance_of(LinePayService).to receive(:messages) { 'something wrong' }
      post :pay, params: { id: order.id }
      expect(response).to redirect_to(order_path(order.id))
      expect(flash[:alert]).to eq('something wrong')
    end
  end

  describe '#pay_confirm' do
    it '付款成功' do
      allow_any_instance_of(LinePayService).to receive(:pay).and_return(true)
      allow_any_instance_of(LinePayService).to receive(:transaction_id) { order.transaction_id }
      get :pay_confirm, params: { id: order.id }
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq('付款完成')
    end

    it '付款失敗' do
      allow_any_instance_of(LinePayService).to receive(:pay).and_return(false)
      allow_any_instance_of(LinePayService).to receive(:messages) { 'something wrong' }
      get :pay_confirm, params: { id: order.id }
      expect(response).to redirect_to(orders_path)
      expect(flash[:alert]).to eq('發生錯誤，錯誤訊息： something wrong')
    end
  end
end