FactoryBot.define do
  factory :lobby do
    quiz
    code { Faker::Lorem.word }
    current_question_index { Faker::Number.between(from: 1, to: 5) } #quiz.questions.count + 1 - e bine si asa?
    status { 'pending' }
  end
end
