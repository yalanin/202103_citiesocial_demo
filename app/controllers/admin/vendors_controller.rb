class Admin::VendorsController < Admin::BaseController
  before_action :find_vedor, only: %i[edit update destroy]

  def index
    @vendors = Vendor.all
  end

  def new
    @vendor = Vendor.new
    if flash[:params].present?
      @vendor.assign_attributes(flash[:params])
      @vendor.valid?
    end
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      redirect_to admin_vendors_path, notice: '新增成功'
    else
      # render :new
      flash[:error] = @vendor.errors.full_messages
      flash[:params] = vendor_params.to_h
      redirect_to new_admin_vendor_path
    end
  end

  def edit; end

  def update
    if @vendor.update(vendor_params)
      redirect_to edit_admin_vendor_path(@vendor), notice: '更新成功'
    else
      # render :edit
      flash[:error] = @vendor.errors.full_messages
      redirect_to edit_admin_vendor_path(@vendor)
    end
  end

  def destroy
    @vendor.destroy
    redirect_to admin_vendors_path, notice: '廠商已刪除'
  end

  private

  def find_vedor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:title, :description, :online)
  end
end
