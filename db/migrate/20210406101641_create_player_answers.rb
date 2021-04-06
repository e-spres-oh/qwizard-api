class CreatePlayerAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :player_answers do |t|

      t.timestamps
    end
  end
end
