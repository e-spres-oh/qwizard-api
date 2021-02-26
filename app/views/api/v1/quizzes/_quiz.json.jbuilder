json.extract! quiz, :id, :title, :created_at, :updated_at, :user_id
json.image_url quiz.image.attached? ? url_for(quiz.image) : nil
