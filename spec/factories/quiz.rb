FactoryBot.define do
  factory :quiz do
    user
    title { Faker::Educator.subject }
  end
end