class CreatePlayerAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :player_answers do |t|
      t.belongs_to :player, null: false, foreign_key: true
      t.belongs_to :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
