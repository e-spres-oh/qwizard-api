# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :lobby
  has_many :player_answers, dependent: :destroy
end
