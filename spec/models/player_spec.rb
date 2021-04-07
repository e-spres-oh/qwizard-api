# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if hat, name are present and it belongs to a lobby' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = described_class.new(hat: 1, name: 'Name', lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if it does not belong to a lobby' do
    player = described_class.new(hat: 1, name: 'Name')
    expect(player).not_to be_valid
  end

  it 'is invalid if hat missing' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = described_class.new(name: 'Name', lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if name missing' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = described_class.new(hat: 1, lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if name and hat are missing' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = described_class.new(lobby: lobby)
    expect(player).not_to be_valid
  end
end