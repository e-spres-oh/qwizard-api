class CreatePlayerAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :player_answers do |t|
      t.belongs_to :player, foreign_key: true
      t.belongs_to :answer, foreign_key: true

      t.timestamps
    end
  end
end
