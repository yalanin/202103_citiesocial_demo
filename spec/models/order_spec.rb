require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:product) { create(:product, :with_skus, sell_price: 15) }
  let(:order) { create(:order) }
  let(:order1) { create(:order, :with_order_items, product: product) }

  context 'Instance Method' do
    describe '#total_price' do
      it '計算訂單金額' do
        expect(order1.total_price.to_i).to eq(90)
      end
    end

    describe 'AASM' do
      it '初始狀態為 pending，且可付款' do
        expect(order.state).to eq('pending')
        expect(order.may_pay?).to be true
      end

      it '檢查不可以走的狀態' do
        expect(order.may_deliver?).to be false
        order.pay!(transaction_id: SecureRandom.hex(10))
        expect(order.may_pay?).to be false
        order.deliver!
        expect(order.may_pay?).to be false
        order.cancel!
        expect(order.may_pay?).to be false
        expect(order.may_deliver?).to be false
      end

      it '付款之後收到第三方通知，狀態更改為成功' do
        order.pay!(transaction_id: SecureRandom.hex(10))
        order.deliver!
        expect(order.state).to eq('delivered')
      end

      it '任何狀態的訂單都能取消' do
        expect(order.may_cancel?).to be true
        order.pay!(transaction_id: SecureRandom.hex(10))
        expect(order.may_cancel?).to be true
        order.deliver!
        expect(order.may_cancel?).to be true
      end
    end
  end
end