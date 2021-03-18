class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title
      t.boolean :is_correct, default: false

      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
