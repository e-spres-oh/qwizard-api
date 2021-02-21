# frozen_string_literal: true

class NotifyQuestionEndJob < ApplicationJob
  def perform(lobby_id:)
    lobby = Lobby.find(lobby_id)
    Pusher.trigger(lobby.code, Lobby::QUESTION_END, {})
  end
end
