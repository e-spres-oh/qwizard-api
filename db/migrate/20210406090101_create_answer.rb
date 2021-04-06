class CreateAnswer < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.boolean :is_correct
      t.string :title
      t.timestamps
    end
  end
end
