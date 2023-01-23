FactoryBot.define do
  factory :order_item do
    order_id { Faker::Number.between(from: 1, to: 20) }
    sku_id { Faker::Number.between(from: 1, to: 20) }
    product_id { Faker::Number.between(from: 1, to: 20) }
    quantity { Faker::Number.between(from: 50, to: 500) }
    order
    sku
    product
  end
end