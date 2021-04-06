class AddQuestionToQuizzes < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :quiz, foreign_key: true
  end
end
