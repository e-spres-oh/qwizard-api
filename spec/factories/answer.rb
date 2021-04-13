FactoryBot.define do
  factory :answer do
    question
    title { Faker::Lorem.sentence }
    is_correct { Faker::Number.between(from: 0, to: 1) }
  end
end