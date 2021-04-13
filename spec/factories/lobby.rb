FactoryBot.define do
    factory :lobby do
      quiz
      code { Faker::Code.npi }
      current_question_index { Faker::Number.between(from: 1, to: 60) }
      status { Faker::Number.between(from: 0, to: 2) }
    end
  end
  