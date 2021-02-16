# frozen_string_literal: true

class Question < ApplicationRecord
  validates :title, presence: true
  validates :time_limit, presence: true
  validates :points, presence: true
  validates :answer_type, presence: true
  validates :order, presence: true

  enum answer_type: [:single, :multiple]
end
