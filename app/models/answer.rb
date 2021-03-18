# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :title, presence: true

  belongs_to :question
end
