FactoryBot.define do
  factory :answer do
    question
    title { Faker::Food.description }
    is_correct { Faker::Boolean.boolean }
  end
end
