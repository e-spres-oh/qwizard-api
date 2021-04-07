class AddLobbyToQuizzes < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :lobbies, :quiz, foreign_key: true
  end
end
