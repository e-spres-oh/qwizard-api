class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.integer :hat
      t.string :name
      t.belongs_to :lobby, null: false, foreign_key: true

      t.timestamps
    end
  end
end
