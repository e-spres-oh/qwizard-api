FactoryBot.define do
  factory :player do
    lobby
    hat { Faker::Number.between(from: 0, to: 7) }
    name { Faker::Name.name }
  end
end
