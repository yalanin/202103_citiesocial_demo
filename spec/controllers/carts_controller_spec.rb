require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }
  login_user


  describe '#destroy' do
    it '清空購物車' do
      delete :destroy
      expect(session[:cart_9876]).to eq(nil)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('購物車已清空')
    end
  end

  describe '#checkout' do
    it '結帳' do
      get :checkout
      expect(user.orders.build).to be_a Order
    end
  end
end