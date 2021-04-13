FactoryBot.define do
  factory :quiz do
    title { Faker::Educator.subject }
  end
end