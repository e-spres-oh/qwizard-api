FactoryBot.define do
  factory :question do
    quiz
    title { 'question?' }
    time_limit { 30 }
    points { 100 }
    order { quiz.questions.count + 1 }
    answer_type { 'single' }
  end
end