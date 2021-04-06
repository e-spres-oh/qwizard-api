class AddPlayerToLobbies < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :players, :lobbies, foreign_key: true
  end
end
