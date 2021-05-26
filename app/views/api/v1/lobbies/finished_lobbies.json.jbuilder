json.array! @result do |res|
  json.partial! 'lobby', lobby: res
  json.quiz res.quiz
end
