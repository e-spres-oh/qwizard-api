class AddQuizzesToUser < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :quizzes, :user, foreign_key: true
  end
end
