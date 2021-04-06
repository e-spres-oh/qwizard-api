# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if all attributes are present and belongs to a lobby' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = described_class.new(
      hat: '1',
      name: 'Alex',
      lobby: lobby
    )
    expect(player).to be_valid
  end

  it 'is not valid if hat is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = described_class.new(
      name: 'Alex',
      lobby: lobby
    )
    expect(player).not_to be_valid
  end

  it 'is not valid if name is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = described_class.new(
      hat: '1',
      lobby: lobby
    )
    expect(player).not_to be_valid
  end

  it 'is not valid if lobby is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = described_class.new(
      hat: '1',
      name: 'Alex',
    )
    expect(player).not_to be_valid
  end
end
