class AddPlayerAnswerToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :player_answers, :players, foreign_key: true
  end
end
