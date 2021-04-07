# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  has_many :player_answers
  validates :is_correct, inclusion: [true, false]
  validates :is_correct, exclusion: [nil]
  validates :title, presence: true
end
