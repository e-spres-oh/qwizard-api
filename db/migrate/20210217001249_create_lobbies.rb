class CreateLobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :lobbies do |t|
      t.string :code
      t.integer :status
      t.integer :current_question_index, default: 1

      t.belongs_to :quiz, foreign_key: true

      t.timestamps
    end
  end
end
