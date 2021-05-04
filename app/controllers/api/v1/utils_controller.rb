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
    product = Product.friendly.find(params[:id])
    Product.friendly.find(params['id'])
    if product
      cart = Cart.from_hash(session[:cart_9876])
      cart.add_item(product.id, params[:quantity])
      session[:cart_9876] = cart.serialize
      render json: { status: 'ok', items: cart.items.count }
    else
      render json: { status: 'failed', message: '商品不存在' }
    end
  end
end
