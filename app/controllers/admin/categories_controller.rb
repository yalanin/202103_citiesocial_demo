class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, only: %i[edit update destroy]

  def index
    @categories = Category.order(position: :asc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: '商品分類已新增'
    else
      flash[:error] = @category.errors.full_messages
      flash[:params] = category_params.to_h
      redirect_to new_admin_category_path
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to edit_admin_category_path(@category), notice: '分類已更新'
    else
      flash[:error] = @category.errors.full_messages
      redirect_to edit_admin_category_path(@category)
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: '分類已刪除'
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
