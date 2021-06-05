class LinePayService
  attr_accessor :code, :messages, :payment_url, :order_id, :transaction_id

  def initialize(order)
    @order = order
  end

  def pay_now
    url = "#{ENV['line_pay_domain']}/v2/payments/request"
    @result = line_pay_request('request', url)
    if success?
      @payment_url = @result['info']['paymentUrl']['web']
    else
      @messages = @result['returnMessage']
      false
    end
  end

  def confirm(transaction_id)
    url = "#{ENV['line_pay_domain']}/v2/payments/#{transaction_id}/confirm"
    @result = line_pay_request('confirm', url)
    if success?
      @order_id = @result['info']['orderId']
      @transaction_id = @result['info']['transactionId']
    else
      @code = @result['returnCode']
      @messages = @result['returnMessage']
      false
    end
  end

  def cancel
    url = "#{ENV['line_pay_domain']}/v2/payments/#{@order.transaction_id}/refund"
    @result = line_pay_request('refund', url)
    if success?
      true
    else
      @messages = @result['returnMessage']
      false
    end
  end

  def pay
    url = "#{ENV['line_pay_domain']}/v2/payments/request"
    @result = line_pay_request('pay', url)
    if success?
      @payment_url = @result['info']['paymentUrl']['web']
    else
      @messages = @result['returnMessage']
      false
    end
  end

  private

  def line_pay_request(cmd, url)
    response = Faraday.post(url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
      req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_key']
      req.body = method("#{cmd}_params".to_sym).call unless cmd == 'refund'
    end
    JSON.parse(response.body)
  end

  def success?
    @result['returnCode'] == '0000'
  end

  def request_params
    {
      productName: 'Citiesocial Demo Pay Test',
      amount: @order.total_price.to_i,
      currency: 'TWD',
      confirmUrl: 'http://localhost:3000/orders/confirm',
      orderId: @order.order_number
    }.to_json
  end

  def confirm_params
    {
      amount: @order.total_price.to_i,
      currency: 'TWD'
    }.to_json
  end

  def pay_params
    {
      productName: 'Citiesocial Demo Pay Test',
      amount: @order.total_price.to_i,
      currency: 'TWD',
      confirmUrl: "http://localhost:3000/orders/#{@order.id}/pay_confirm",
      orderId: @order.order_number
    }.to_json
  end
end
