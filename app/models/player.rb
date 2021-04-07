# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :player_answers
  belongs_to :lobby
  validates :lobby, presence: true
  validates :hat, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :name, presence: true
end
