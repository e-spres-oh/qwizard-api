# frozen_string_literal: true

class Quiz < ApplicationRecord
  validates :title, presence: true
  has_many :questions, dependent: :destroy
  has_many :lobbies, dependent: :destroy
end
