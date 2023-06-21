require 'rails_helper'

RSpec.describe Api::V1::UtilsController, type: :controller do
  login_user

  describe '#subscribe' do
    it 'should subscribe success' do
      post :subscribe, params: { 'subscribe': { 'email': 'subscribe@test.com' } }
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end

    it 'should subscribe failed' do
      post :subscribe, params: { 'subscribe': { 'email': '' } }
      expect(JSON.parse(response.body)['status']).to eq('failed')
      expect(JSON.parse(response.body)['messages']).not_to be_empty
    end
  end

  describe '#cart' do
    let!(:product) { create(:product, :with_skus, sell_price: 3, on_sell: true) }

    it 'should increace cart success' do
      post :cart, params: { id: 1, sku: 1, quantity: 3 }
      expect(JSON.parse(response.body)['status']).to eq('ok')
      expect(JSON.parse(response.body)['items']).to eq(session[:cart_9876]['items'].count)
    end
  end
end