class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :hat

      t.belongs_to :lobby, foreign_key: true

      t.timestamps
    end
  end
end
