class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.float :points
      t.integer :order
      t.float :time_limit 
      t.integer :answer_type
      t.belongs_to :quiz

      t.timestamps
    end
  end
end
