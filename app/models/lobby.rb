# frozen_string_literal: true

class Lobby < ApplicationRecord
  belongs_to :quiz
  has_many :players, dependent: :destroy
  validates :quiz, presence: true
  validates :code, presence: true
  validates :current_question_index, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, numericality: { only_integer: true }

  enum status: [:pending, :in_progress, :finished]
end
