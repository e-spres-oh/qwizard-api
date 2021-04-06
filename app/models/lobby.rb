# frozen_string_literal: true

class Lobby < ApplicationRecord
  validates :code, presence: true
  belongs_to :quiz
  has_many :players, dependent: :destroy
end
