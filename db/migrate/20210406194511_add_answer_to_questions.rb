class AddAnswerToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :questions, foreign_key: true
  end
end
