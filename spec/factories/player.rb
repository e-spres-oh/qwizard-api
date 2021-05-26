FactoryBot.define do
  factory :player do
    lobby
    name { Faker::Name.first_name }
    hat { Player.hats.values.sample }
    user
  end
end