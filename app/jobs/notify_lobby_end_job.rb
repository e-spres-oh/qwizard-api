# frozen_string_literal: true

class NotifyLobbyEndJob < ApplicationJob
  def perform(lobby_id:)
    lobby = Lobby.find(lobby_id)

    lobby.update!(status: :finished)
    Pusher.trigger(lobby.code, Lobby::LOBBY_END, {})
  end
end
