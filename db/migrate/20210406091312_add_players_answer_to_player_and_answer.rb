class AddPlayersAnswerToPlayerAndAnswer < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :player_answers, :player, foreign_keys: true 
    add_belongs_to :player_answers, :answer, foreign_keys: true 
  end
end
