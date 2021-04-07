# frozen_string_literal: true

class Player < ApplicationRecord
    validates :hat, :name, presence: true

    belongs_to :lobby
end