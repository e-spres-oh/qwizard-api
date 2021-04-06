# frozen_string_literal: true

class Question < ApplicationRecord
    validates :answer_type, :order, :points, :time_limit, :title, presence: true

    belongs_to :quiz
    has_many :answers, dependent: :destroy
  end
