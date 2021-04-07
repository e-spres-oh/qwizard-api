class AddAnswerToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :question, foreign_key: true
  end
end
