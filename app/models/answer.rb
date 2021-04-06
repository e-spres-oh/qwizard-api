# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :is_correct, :title, presence: true

  belongs_to :question
  has_many :player_answers, dependent: :destroy
end
