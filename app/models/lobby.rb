# frozen_string_literal: true

class Lobby < ApplicationRecord
  PLAYER_JOIN = 'player_join'
  LOBBY_START = 'lobby_start'
  QUESTION_START = 'question_start'
  ANSWER_SENT = 'answer_sent'

  validates :code, presence: true
  validates :status, presence: true
  validates :current_question_index, presence: true

  belongs_to :quiz
  has_many :players, dependent: :destroy

  enum status: [:pending, :in_progress, :finished]
end
