FactoryBot.define do
  factory :answer do
    question
    is_correct { Faker::Boolean.boolean }
    title { Faker::Lorem.sentence(word_count: 5) }
  end
end

FactoryBot.define do
  factory :correct_answer do
    question
    is_correct { true }
    title { Faker::Lorem.sentence(word_count: 5) }
  end
end

FactoryBot.define do
  factory :incorrect_answer do
    question
    is_correct { false }
    title { Faker::Lorem.sentence(word_count: 5) }
  end
end