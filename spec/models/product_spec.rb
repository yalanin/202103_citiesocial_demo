require 'rails_helper'
require './spec/share/shared_examples_spec.rb'

RSpec.describe Product, type: :model do
  context 'Scope Method' do
    describe '#on_sell' do
      let!(:product1) { create(:product) }
      let!(:product2) { create(:product, on_sell: true) }
      subject { Product.all }

      include_examples 'full scope'

      it 'on sell only' do
        expect(subject.on_sell.size).to eq(1)
        expect(subject.on_sell.map(&:on_sell).uniq.size).to eq(1)
        expect(subject.on_sell.map(&:on_sell).uniq[0]).to be true
      end
    end
  end
end