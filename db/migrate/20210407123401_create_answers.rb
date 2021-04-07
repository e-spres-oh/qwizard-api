class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.boolean :is_correct
      t.string :title
      t.belongs_to :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
