# frozen_string_literal: true

class PlayerAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :player
  validates :answer, presence: true
  validates :player, presence: true
end
