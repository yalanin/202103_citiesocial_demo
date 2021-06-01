class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku, optional: true
  belongs_to :product

  def total_price
    quantity * product.sell_price
  end
end
