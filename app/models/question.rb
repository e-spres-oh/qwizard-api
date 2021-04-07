# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, inverse_of: :order
  validates :quiz, presence: true
  validates :answers, presence: true
  validates :title, presence: true
  validates :points, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :order, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :time_limit, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :answer_type, presence: true, numericality: { only_integer: true }
end
