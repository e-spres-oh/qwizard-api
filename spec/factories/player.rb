FactoryBot.define do
  factory :player do
    lobby
    name { Faker::Lorem.question }
    hat { 'star' }
  end
end