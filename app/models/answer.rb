# frozen_string_literal: true

class Answer < ApplicationRecord
    belongs_to :question
    has_many :player_answers, dependent: :destroy
  end
