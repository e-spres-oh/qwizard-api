# frozen_string_literal: true

class Player < ApplicationRecord
    validates :hat, :name, presence: true

    belongs_to: lobbies
    has_many: player_answers
end