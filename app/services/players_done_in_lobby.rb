# frozen_string_literal: true

class PlayersDoneInLobby
  def initialize(lobby_id)
    @lobby = Lobby.find(lobby_id)
  end

  def call
    @lobby.players.to_a.select do |p|
      p.player_answers.any? { |pa| pa.answer.question.id.to_s == params[:question_id] }
    end
  end
end
