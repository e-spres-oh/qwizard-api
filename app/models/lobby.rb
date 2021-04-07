# frozen_string_literal: true

class Lobby < ApplicationRecord
  belongs_to :quiz
  has_many :players
  validates :quiz, presence: true
  validates :code, presence: true
  validates :current_question_index, presence: true, numericality: {only_integer: true}
  validates :status, presence: true, numericality: {only_integer: true}
end
