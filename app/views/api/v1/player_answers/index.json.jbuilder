json.array! @player_answers do |player_answer|
  json.partial! 'player_answer', player_answer: player_answer
end
