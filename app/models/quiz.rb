# frozen_string_literal: true

class Quiz < ApplicationRecord
  validates :title, presence: true

  has_may :questions, dependent: :destroy
end
