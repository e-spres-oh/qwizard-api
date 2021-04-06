# frozen_string_literal: true

class PlayerAnswer < ApplicationRecord
    belongs_to: players
    belongs_to: answers
end