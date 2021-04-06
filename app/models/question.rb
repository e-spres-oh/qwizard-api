# frozen_string_literal: true

class Question < ApplicationRecord
    validates :title, answer_type, order, points, time_limit, presence: true

    belongs_to :quiz
end