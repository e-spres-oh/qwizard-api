# frozen_string_literal: true

class NotifyQuestionEndJob < ApplicationJob
  def perform(lobby_id:)
    lobby = Lobby.find(lobby_id)
    Pusher.trigger(lobby.code, Lobby::QUESTION_END, {})

    NotifyQuestionStartJob.set(wait: Lobby::SHOW_SCORE_DELAY_SECONDS)
                          .perform_later(lobby_id: lobby.id, question_index: lobby.current_question_index + 1)
  end
end
