class FixAnswerQuestionFk < ActiveRecord::Migration[6.1]
  def change
    rename_column :answers, :questions_id, :question_id
  end
end
