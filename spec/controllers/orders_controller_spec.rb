require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { Cart.new }
  let(:product) { create(:product, :with_skus, sell_price: 3) }
  let(:order_item) { create(:order_item, product: product, quantity: 12) }
  let(:order) { create(:order, :with_order_items, product: product, user: user) }
  let(:service) { LinePayService.new(order) }
  login_user

  describe '#index' do
    it '顯示清單' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
    it '建立清單' do
      VCR.use_cassette "data_search" do
        cart.add_sku(product.id, 2, product.skus.first.id)
        controller.session[:cart_9876] = cart.serialize
        allow(service).to receive(:line_pay_request).and_return(pay_success)
        result = service.pay_now
        post :create, params: { order: { recipient: order.recipient, tel: order.tel, address: order.address, note: '' } }
        expect(response).to redirect_to(checkout_cart_path)
      end
    end
  end

  private

  def pay_success
    {
      'returnCode'=> '0000',
      'info'=> {
        'paymentUrl'=> {
          'web'=> 'https://linepay_url'
        }
      }
    }
  end
end