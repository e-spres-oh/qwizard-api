# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :player_answers, dependent: :destroy
  belongs_to :lobby
  validates :lobby, presence: true
  validates :hat, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  enum hat: [:star, :earth, :spiral, :gnome, :nature, :fire, :swamp, :water]
end
