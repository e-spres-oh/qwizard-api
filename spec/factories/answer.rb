FactoryBot.define do
  factory :answer do
    question
    title { Faker::Lorem.word }
    is_correct { Faker::Boolean.boolean }
  end
end
