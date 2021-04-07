# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :questions, inverse_of: :quiz
  has_one :lobby
  validates :questions, presence: true, allow_blank: true
  validates :lobby, presence: true, allow_nil: true
  validates :title, presence: true
end
