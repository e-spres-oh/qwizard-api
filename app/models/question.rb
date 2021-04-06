# frozen_string_literal: true

class Question < ApplicationRecord
    belongs_to :quiz
    has_many :answers, dependent: :destroy
  end
