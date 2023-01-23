FactoryBot.define do
  factory :order do
    order_number { SecureRandom.hex(5) }
    recipient { Faker::Crypto.sha1 }
    tel { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.full_address }
    user_id { Faker::Number.between(from: 1, to: 20) }
    paid_at { Time.now }
    transaction_id { Faker::Crypto.sha1 }
  end
end