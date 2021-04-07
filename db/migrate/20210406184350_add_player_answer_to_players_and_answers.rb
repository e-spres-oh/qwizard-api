class AddPlayerAnswerToPlayersAndAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :player_answers, :player, foreign_key: true
    add_belongs_to :player_answers, :answer, foreign_key: true
  end
end
