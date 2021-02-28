# frozen_string_literal: true

class Lobby < ApplicationRecord
  PLAYER_JOIN = 'player_join'
  LOBBY_START = 'lobby_start'
  LOBBY_END = 'lobby_end'
  QUESTION_START = 'question_start'
  QUESTION_END = 'question_end'
  ANSWER_SENT = 'answer_sent'

  QUESTION_COUNTDOWN_DELAY_SECONDS = 3.seconds
  SHOW_SCORE_DELAY_SECONDS = 10.seconds

  validates :code, presence: true
  validates :status, presence: true
  validates :current_question_index, presence: true

  belongs_to :quiz
  has_many :players, dependent: :destroy

  enum status: [:pending, :in_progress, :finished]

  scope :finished, -> { where(status: :finished) }
end
