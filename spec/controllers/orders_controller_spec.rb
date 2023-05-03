require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { Cart.new }
  let(:product) { create(:product, :with_skus, sell_price: 3) }
  let(:order_item) { create(:order_item, product: product, quantity: 12) }
  let(:order) { create(:order, :with_order_items, product: product, user: user) }
  let(:service) { LinePayService.new(order) }
  before do
    cart.add_sku(product.id, 2, product.skus.first.id)
    controller.session[:cart_9876] = cart.serialize
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
end