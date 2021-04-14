# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    quiz
    title { Faker::Lorem.question }
    time_limit { Faker::Number.between(from: 60, to: 120) }
    points { Faker::Number.between(from: 0, to: 200) }
    order { quiz.questions.count + 1 }
    answer_type { 'single' }
  end
end
