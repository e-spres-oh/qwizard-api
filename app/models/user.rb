# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :password, presence: true
  validates :token, uniqueness: { allow_blank: true }

  has_many :quizzes, dependent: :destroy
  has_many :players, dependent: :destroy

  enum hat: [:star, :earth, :spiral, :gnome, :nature, :fire, :swamp, :water]
end
