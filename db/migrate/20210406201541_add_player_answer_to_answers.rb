class AddPlayerAnswerToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :player_answers, :answers, foreign_key: true
  end
end
