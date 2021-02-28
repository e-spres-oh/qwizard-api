# frozen_string_literal: true

class Player < ApplicationRecord
  validates :name, presence: true
  validates :hat, presence: true

  belongs_to :lobby
  has_many :player_answers, dependent: :destroy
  belongs_to :user, optional: true

  enum hat: [:star, :earth, :spiral, :gnome, :nature, :fire, :swamp, :water]
end
