# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if hat, name present' do
    quiz = Quiz.create(title: 'Test')
    lobby = Lobby.create(code: 'Test', current_question_index: 2, status: 2, quiz: quiz)
    player = described_class.new(hat: 2, name: 'Test', lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if not binded to lobby' do
    quiz = Quiz.create(title: 'Test')
    lobby = Lobby.create(code: 'Test', current_question_index: 2, status: 2, quiz: quiz)
    player = described_class.new(hat: 2, name: 'Test')
    expect(player).not_to be_valid
  end

  it 'is invalid if hat, name missing' do
    quiz = Quiz.create(title: 'Test')
    lobby = Lobby.create(code: 'Test', current_question_index: 2, status: 2, quiz: quiz)
    player = described_class.new
    expect(player).not_to be_valid
  end

end