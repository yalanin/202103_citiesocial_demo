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
      redirect_to root_path, notice: '訂單儲存完成'
    else
      render 'carts/checkout'
    end
  end

  private

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end
