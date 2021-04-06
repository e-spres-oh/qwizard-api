# frozen_string_literal: true

class PlayerAnswer < ApplicationRecord
  belongs_to :player
  belongs_to :answer
end
