FactoryBot.define do
  factory :subscribe do
    email { Faker::Internet.free_email(name: Faker::Name.first_name) }
  end
end