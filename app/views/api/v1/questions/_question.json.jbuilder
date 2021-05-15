json.extract! question, :id, :title, :time_limit, :points, :answer_type, :order, :created_at, :updated_at, :quiz_id
json.image_url question.image.attached? ? url_for(question.image) : nil
