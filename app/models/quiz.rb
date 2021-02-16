# frozen_string_literal: true

class Quiz < ApplicationRecord
  validates :title, presence: true

  has_many :questions, dependent: :destroy
end
