class ProductsController < ApplicationController
  def index
    @products = Product.on_sell.order(updated_at: :desc).includes(:vendor)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end
end
