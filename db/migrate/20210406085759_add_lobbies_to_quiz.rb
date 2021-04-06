class AddLobbiesToQuiz < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :lobbies, :quiz, foreign_keys: true 
  end
end
