FactoryBot.define do
  factory :lobby do
    quiz
    code { Faker::Alphanumeric.alpha(number: 6) }
    status { Lobby.statuses[:pending] }
    current_question_index { 1 }
  end
end