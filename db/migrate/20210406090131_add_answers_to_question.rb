class AddAnswersToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :questions, foreign_keys: true 
  end
end
