class ProductsController < ApplicationController
  def index
    @products = Product.where(on_sell: true).order(updated_at: :desc).includes(:vendor)
  end

  def show
  end
end
