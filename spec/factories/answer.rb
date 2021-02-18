FactoryBot.define do
  factory :answer do
    question
    title { Faker::Lorem.sentence }
    is_correct { false }
  end
end