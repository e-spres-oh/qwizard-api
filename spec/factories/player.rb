FactoryBot.define do
  factory :player do
    lobby
    name { Faker::Name.name }
    hat { "gnome" }
  end
end