require 'rails_helper'

RSpec.describe LinePayService, type: :class do
  let(:service) { LinePayService.new(order1) }

  context 'instance method' do
    include_context 'share order'
    describe '#pay_now' do
      it 'should get payment url' do
        allow(service).to receive(:line_pay_request).and_return(pay_success)
        result = service.pay_now
        expect(service.send(:success?)).to be true
        expect(result).to eq('https://linepay_url')
      end
    end

    describe '#confirm' do
      it 'should get orderId and transactionId' do
        allow(service).to receive(:line_pay_request).and_return(confirm_success)
        result = service.confirm('XY9999')
        expect(service.send(:success?)).to be true
      end

      it 'should get confirm error message' do
        allow(service).to receive(:line_pay_request).and_return(failed_response)
        result = service.confirm('XY9999')
        expect(service.send(:success?)).to be false
      end
    end

    describe '#cancel' do
      it 'should get success response' do
        allow(service).to receive(:line_pay_request).and_return(cancel_success)
        result = service.cancel
        expect(service.send(:success?)).to be true
      end
    end

    include_examples 'line pay error response'
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

  def confirm_success
    {
      'returnCode'=> '0000',
      'info'=> {
        'orderId'=> 'AB1234',
        'transactionId'=> 'XY9999'
      }
    }
  end

  def cancel_success
    { 'returnCode'=> '0000' }
  end

  def failed_response
    {
      'returnCode'=> '1000',
      'returnMessage'=> 'something went wrong'
    }
  end
end