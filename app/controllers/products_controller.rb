class ProductsController < ApplicationController
  def index
    @products = Product.on_sell.order(updated_at: :desc).includes(:vendor)
  end

  def show
  end
end
