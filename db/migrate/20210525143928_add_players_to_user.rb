class AddPlayersToUser < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :players, :user, foreign_key: true
  end
end
