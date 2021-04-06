# frozen_string_literal: true

class PlayerAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :player
end
