# frozen_string_literal: true

class AnswerQuestion
  def call(lobby_id:, player:, answers:)
    lobby = Lobby.find(lobby_id)
    question = lobby.quiz.questions.find_by(order: lobby.current_question_index)

    create_player_answers!(player, question, answers)
    notify_answer_count(lobby)

    question
  end

  private

  def create_player_answers!(player, question, answers)
    PlayerAnswer.where(player: player, answer_id: question.answers.map(&:id)).destroy_all

    answers.each do |id|
      answer = Answer.find(id)
      PlayerAnswer.create(player: player, answer: answer)
    end
  end

  def notify_answer_count(lobby)
    players = lobby.players.to_a.select do |p|
      p.player_answers.any? { |pa| pa.answer.question.order == lobby.current_question_index }
    end
    Pusher.trigger(lobby.code, Lobby::ANSWER_SENT, { answer_count: players.count })
  end
end
