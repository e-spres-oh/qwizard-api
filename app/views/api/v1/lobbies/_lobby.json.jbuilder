json.extract! lobby, :id, :code, :status, :current_question_index, :quiz_id, :created_at, :updated_at
json.quiz_master lobby.quiz.user.username
