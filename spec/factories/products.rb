FactoryBot.define do
  factory :product do
    name { "MyString" }
    vendor { nil }
    list_price { "9.99" }
    sell_price { "9.99" }
    on_sell { false }
    code { "MyString" }
    deleted_at { "2021-03-23 21:47:46" }
  end
end
