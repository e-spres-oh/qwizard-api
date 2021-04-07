class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.integer :hat
      t.string :name
      t.timestamps
    end
  end
end
