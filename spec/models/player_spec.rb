# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if hat, name and lobby present' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = Lobby.new(code: 1, quiz: quiz)
    player = described_class.new(name: 'player 1', hat: 1, lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if hat, name and lobby missing' do
    player = described_class.new
    expect(player).not_to be_valid
  end

  it 'is invalid if name missing' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = Lobby.new(code: 1, quiz: quiz)
    player = described_class.new(hat: 1, lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if hat missing' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = Lobby.new(code: 1, quiz: quiz)
    player = described_class.new(name: "player 1", lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if lobby missing' do
    player = described_class.new(hat: 1, name: "player 1")
    expect(player).not_to be_valid
  end
end
