# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :password, presence: true

  enum hat: [:star, :earth, :spiral, :gnome, :nature, :fire, :swamp, :water]
end
