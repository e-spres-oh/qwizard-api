json.array! @result do |res|
  json.partial! 'lobby', lobby: res.lobby
  json.quiz res.lobby.quiz
end
