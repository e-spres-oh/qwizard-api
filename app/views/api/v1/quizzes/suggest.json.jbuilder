json.partial! 'api/v1/questions/question', question: @question
json.answers @answers.each do |answer|
  json.partial! 'api/v1/answers/answer', answer: answer
end
