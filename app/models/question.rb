# frozen_string_literal: true

class Question < ApplicationRecord
    validates :title, presence: true
end