class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku, optional: true
  belongs_to :product
end
