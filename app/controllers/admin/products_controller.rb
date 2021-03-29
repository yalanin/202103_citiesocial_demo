class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[edit update destroy]

  def index
    @products = Product.includes(:vendor).all
  end

  def new
    @product = flash[:params] ? Product.new(flash[:params]) : Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: '商品已新增'
    else
      flash[:error] = @product.errors.full_messages
      flash[:params] = product_params.to_h
      redirect_to new_admin_product_path
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to edit_admin_product_path(@product)
    else
      flash[:error] = @product.errors.full_messages
      redirect_to edit_admin_product_path(@product)
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: '商品已刪除'
  end

  private

  def find_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :list_price, :sell_price, :on_sell)
  end
end
