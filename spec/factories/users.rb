FactoryBot.define do
  factory :user do
    email { Faker::Internet.free_email(name: Faker::Name.first_name) }
    password { SecureRandom.hex(10) }
    name { Faker::Name.name }
  end
end