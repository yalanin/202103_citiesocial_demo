class Api::V1::UtilsController < ApplicationController
  def subscribe
    email = params['subscribe']['email']
    sub = Subscribe.new(email: email)
    if sub.save
      render json: { status: 'ok'}
    else
      # render json: { status: 'failed', messages: sub.errors.full_messages, email: email }
      render json: { status: 'failed', messages: sub.errors.full_messages }
    end
  end

  def cart
    product = Product.joins(:skus).find_by(skus: { id: params[:sku] }) if params[:sku].present?
    product ||= Product.friendly.find(params[:id])
    if product
      current_cart.add_sku(product.code, params[:quantity].to_i, params[:sku])
      session[:cart_9876] = current_cart.serialize
      render json: { status: 'ok', items: current_cart.items.count }
    else
      render json: { status: 'failed', message: '商品不存在' }
    end
  end
end
