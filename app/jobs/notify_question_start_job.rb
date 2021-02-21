# frozen_string_literal: true

class NotifyQuestionStartJob < ApplicationJob
  def perform(lobby_id:, question_index:)
    lobby = Lobby.find(lobby_id)

    lobby.update!(current_question_index: question_index)
    Pusher.trigger(lobby.code, Lobby::QUESTION_START, { question_index: question_index })

    question = lobby.quiz.questions.find_by(order: question_index)
    NotifyQuestionEndJob.set(wait: question.time_limit.seconds + Lobby::QUESTION_COUNTDOWN_DELAY_SECONDS)
                        .perform_later(lobby_id: lobby.id)
  end
end
