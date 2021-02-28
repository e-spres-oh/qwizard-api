json.array! @lobbies do |lobby|
  json.partial! 'lobby', lobby: lobby
  json.quiz do
    json.partial! 'api/v1/quizzes/quiz', quiz: lobby.quiz
  end
end
