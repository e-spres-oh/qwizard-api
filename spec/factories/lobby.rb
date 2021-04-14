# frozen_string_literal: true

FactoryBot.define do
  factory :lobby do
    quiz
    code { Faker::Lorem.word }
    status { 'pending' }
    current_question_index { Faker::Number.between(from: 1, to: quiz.questions.count + 1) }
  end
end
