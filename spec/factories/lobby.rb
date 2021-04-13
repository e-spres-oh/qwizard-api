FactoryBot.define do
  factory :lobby do
    quiz
    code { Faker::Number.hexadecimal(8).upcase! }
    current_question_index { Faker::Number.between(0,quiz.questions.count) }
    status { 'pending' }
  end
end