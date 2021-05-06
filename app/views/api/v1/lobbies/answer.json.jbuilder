json.array! @answers do |answer|
  json.partial! 'api/v1/answers/answer', answer: answer
end
