# frozen_string_literal: true

class CalculateScore
  def call(player)
    score = 0
    grouped_player_answers = player.player_answers.group_by { |player_answer| player_answer.answer.question }

    grouped_player_answers.each do |question, player_answers|
      next unless answered_correctly?(player_answers, question)

      score += question.points
    end

    score
  end

  private

  def answered_correctly?(player_answers, question)
    player_answers.none? { |player_answer| player_answer.answer.is_correct == false } &&
      player_answers.count == question.answers.select(&:is_correct).count
  end
end
