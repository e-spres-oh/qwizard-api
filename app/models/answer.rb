# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :title, presence: true
  belongs_to :question
  has_many :player_answers, dependent: :destroy
end
