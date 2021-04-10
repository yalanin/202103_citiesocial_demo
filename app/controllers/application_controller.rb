class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :view_categories, unless: :backend?

  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def view_categories
    @categories = Category.order(position: :asc)
  end

  def backend?
    controller_path.split('/').first == 'Admin'
  end
end
