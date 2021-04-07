# frozen_string_literal: true

class Lobby < ApplicationRecord
    validates :code, :current_question_index, :status, presence: true

    belongs_to :quiz
end