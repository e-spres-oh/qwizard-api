class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :answer_type
      t.integer :order
      t.integer :points
      t.integer :time_limit
      t.string :title
      t.timestamps
    end
  end
end
