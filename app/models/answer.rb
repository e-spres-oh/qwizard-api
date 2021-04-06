# frozen_string_literal: true

class Answer < ApplicationRecord
    validates :title, :is_correct, presence: true

    belongs_to: questions
    has_many: player_answers
end