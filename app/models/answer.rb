# frozen_string_literal: true

class Answer < ApplicationRecord
    validates :title, :is_correct, presence: true
end