FactoryBot.define do
  factory :player do
    lobby
    hat { 'water' }
    name { Faker::Name.name  }
  end
end
