class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.integer :time_limit
      t.integer :points
      t.integer :answer_type
      t.integer :order

      t.timestamps
    end
  end
end
