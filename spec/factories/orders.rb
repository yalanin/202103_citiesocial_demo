FactoryBot.define do
  factory :order do
    recipient { Faker::Crypto.sha1 }
    tel { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.full_address }
    user_id { Faker::Number.between(from: 1, to: 20) }
    paid_at { Time.now }
    transaction_id { Faker::Crypto.sha1 }
    user

    trait :with_order_items do
      transient do
        product { product }
      end
      order_items { build_list :order_item, 2, product: product, quantity: 3 }
    end
  end
end