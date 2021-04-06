class CreateLobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :lobbies do |t|
      t.string :code
      t.integer :current_question_index
      t.integer :status

      t.timestamps
    end
  end
end
