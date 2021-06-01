class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.new(order_params)
    current_cart.items.each do |item|
      if item.sku_id.present?
        @order.order_items.build(sku: item.sku_id, quantity: item.quantity, product_id: item.product.id)
      else
        @order.order_items.build(quantity: item.quantity, product_id: item.product.id)
      end
    end

    if @order.save
      response = Faraday.post("#{ENV['line_pay_domain']}/v2/payments/request") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
        req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_key']
        req.body = pay_params
      end

      result = JSON.parse(response.body)
      if result['returnCode'] == '0000'
        payment_url = result['info']['paymentUrl']['web']
        redirect_to payment_url
      else
        flash[:alert] = result['returnMessage']
        redirect_to checkout_cart_path
      end
    else
      render 'carts/checkout'
    end
  end

  def confirm
    response = Faraday.post("#{ENV['line_pay_domain']}/v2/payments/#{params[:transactionId]}/confirm") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
      req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_key']
      req.body = confirm_params
    end

    result = JSON.parse(response.body)
    if result['returnCode'] == '0000'
      order_id = result['info']['orderId']
      transaction_id = result['info']['transactionId']
      order = current_user.orders.find_by(order_number: order_id)
      order.pay!(transaction_id: transaction_id)
      session[:cart_9876] = nil
      redirect_to root_path, notice: '付款完成'
    else
      redirect_to root_path, alert: '發生錯誤，請聯繫系統人員'
    end
  end

  private

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end

  def pay_params
    {
      productName: 'Citiesocial Demo Pay Test',
      amount: current_cart.total_price.to_i,
      currency: 'TWD',
      confirmUrl: 'http://localhost:3000/orders/confirm',
      orderId: @order.order_number
    }.to_json
  end

  def confirm_params
    {
      amount: current_cart.total_price.to_i,
      currency: 'TWD'
    }.to_json
  end
end
