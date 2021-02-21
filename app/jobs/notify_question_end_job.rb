# frozen_string_literal: true

class NotifyQuestionEndJob < ApplicationJob
  def perform(lobby_id:)
    lobby = Lobby.find(lobby_id)
    Pusher.trigger(lobby.code, Lobby::QUESTION_END, {})

    next_question = lobby.quiz.questions.find_by(order: lobby.current_question_index + 1)

    return NotifyLobbyEndJob.perform_now(lobby_id: lobby.id) if next_question.nil?

    NotifyQuestionStartJob.set(wait: Lobby::SHOW_SCORE_DELAY_SECONDS)
                          .perform_later(lobby_id: lobby.id, question_index: lobby.current_question_index + 1)
  end
end
