json.array! @quizzes do |quiz|
  json.partial! 'quiz', quiz: quiz
end