class Admin::ProductsController < Admin::BaseController
  def index
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

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def product_params
    params.require(:product).permit(:name, :vendor_id, :list_price, :sell_price, :on_sell)
  end
end
