# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, inverse_of: :question
  validates :quiz, presence: true
  validates :answers, presence: true, unless: :contains_a_correct_answer?
  validates :title, presence: true
  validates :points, presence: true, numericality: { only_integer: false, greater_than_or_equal_to: 0 }
  validates :order, presence: true, numericality: { only_integer: false, greater_than_or_equal_to: 0 }
  validates :time_limit, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :answer_type, presence: true, numericality: { only_integer: true }

  def contains_a_correct_answer?
    return false unless answers.present?

    answers.any? { |answer| answer.is_correct == true }
  end
end
