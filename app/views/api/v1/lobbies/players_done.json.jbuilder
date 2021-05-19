json.array! @players do |player|
  json.partial! 'api/v1/players/player', player: player
end
