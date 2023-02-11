require 'rails_helper'

RSpec.describe LinePayService, type: :class do
  let(:line_pay) { double() }

  context 'instance method' do
    describe '#pay_now' do
      it 'should get payment url' do
        allow(line_pay).to receive(:line_pay_request).and_return(pay_success)
        expect(line_pay.line_pay_request[:returnCode]).to eq('0000')
        expect(line_pay.line_pay_request[:info][:paymentUrl][:web]).to eq('https://linepay_url')
      end

      include_examples 'line pay response'
    end

    describe '#confirm' do
      it 'should get orderId and transactionId' do
        allow(line_pay).to receive(:line_pay_request).and_return(confirm_success)
        expect(line_pay.line_pay_request[:returnCode]).to eq('0000')
        expect(line_pay.line_pay_request[:info][:orderId]).to eq('AB1234')
        expect(line_pay.line_pay_request[:info][:transactionId]).to eq('XY9999')
      end

      include_examples 'line pay response'
    end

    describe '#cancel' do
      it 'should get success response' do
        allow(line_pay).to receive(:line_pay_request).and_return(cancel_success)
        expect(line_pay.line_pay_request[:returnCode]).to eq('0000')
      end

      include_examples 'line pay response'
    end
  end

  private

  def pay_success
    {
      returnCode: '0000',
      info: {
        paymentUrl: {
          web: 'https://linepay_url'
        }
      }
    }
  end

  def confirm_success
    {
      returnCode: '0000',
      info: {
        orderId: 'AB1234',
        transactionId: 'XY9999'
      }
    }
  end

  def cancel_success
    { returnCode: '0000' }
  end

  def failed_response
    {
      returnCode: '1000',
      returnMessage: 'something went wrong'
    }
  end
end