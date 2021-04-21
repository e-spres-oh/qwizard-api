json.array! @lobbies do |lobby|
  json.partial! 'lobby', lobby: lobby
end
