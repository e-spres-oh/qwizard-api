# frozen_string_literal: true

class Lobby < ApplicationRecord
    belongs_to :quiz
    has_many :players, dependent: :destroy
  end
