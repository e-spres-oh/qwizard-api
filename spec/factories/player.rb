FactoryBot.define do
  factory :player do
    lobby
    name { Faker::Name.name }
    hat { Faker::Number.between(from: 0, to: 7) }
  end
end