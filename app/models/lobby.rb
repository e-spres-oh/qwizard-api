# frozen_string_literal: true

class Lobby < ApplicationRecord
  validates :code, presence: true
  validates :status, presence: true
  validates :current_question_index, presence: true

  belongs_to :quiz

  enum status: [:pending, :in_progress, :finished]
end
