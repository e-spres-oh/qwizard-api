# frozen_string_literal: true

class Question < ApplicationRecord
  validates :title, presence: true
  validates :order, presence: true
  validates :answer_type, presence: true

  belongs_to :quiz
  has_many :answers, dependent: :destroy
end
