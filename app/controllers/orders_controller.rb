class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only: %i[cancel pay pay_confirm]

  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.new(order_params)
    add_order_items
    if @order.save
      service = LinePayService.new(@order)
      if service.pay_now
        redirect_to service.payment_url
      else
        flash[:alert] = service.messages
        redirect_to checkout_cart_path
      end
    else
      render 'carts/checkout'
    end
  end

  def confirm
    service = LinePayService.new(current_cart)
    if service.confirm(params[:transactionId])
      order_id = service.order_id
      transaction_id = service.transaction_id
      order = current_user.orders.find_by(order_number: order_id)
      order.pay!(transaction_id: transaction_id)
      session[:cart_9876] = nil
      redirect_to root_path, notice: '付款完成'
    else
      redirect_to root_path, alert: "發生錯誤，錯誤訊息：#{service.code} #{service.messages}"
    end
  end

  def cancel
    if @order.paid?
      service = LinePayService.new(@order)
      if service.cancel
        @order.cancel!
        redirect_to orders_path, notice: "訂單 #{@order.order_number} 已取消"
      else
        flash[:alert] = service.messages
        redirect_to orders_path
      end
    else
      @order.cancel!
      redirect_to orders_path, notice: "訂單 #{@order.order_number} 已取消"
    end
  end

  def pay
    service = LinePayService.new(@order)
    if service.pay
      redirect_to service.payment_url
    else
      flash[:alert] = service.messages
      redirect_to order_path
    end
  end

  def pay_confirm
    service = LinePayService.new(@order)
    if service.pay
      transaction_id = service.transaction_id
      @order.pay!(transaction_id: transaction_id)
      redirect_to orders_path, notice: '付款完成'
    else
      redirect_to orders_path, alert: "發生錯誤，錯誤訊息：#{service.code} #{service.messages}"
    end
  end

  private

  def add_order_items
    current_cart.items.each do |item|
      if item.sku_id.present?
        @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity, product_id: item.product.id)
      else
        @order.order_items.build(quantity: item.quantity, product_id: item.product.id)
      end
    end
  end

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end

  def find_order
    @order = current_user.orders.find(params[:id])
  end
end
