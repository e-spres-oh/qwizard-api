# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if player and answer are present' do
    quiz = FactoryBot.create(:quiz)
    lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
    player = Player.create(name: 'player', hat: 'star', lobby: lobby)
    question = Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz)
    answer = Answer.create(title: 'answer', question: question)

    player_answer = described_class.new(player: player, answer: answer)
    expect(player_answer).to be_valid
  end

  it 'is invalid if player is missing' do
    quiz = FactoryBot.create(:quiz)
    question = Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz)
    answer = Answer.create(title: 'answer', question: question)

    player_answer = described_class.new(answer: answer)
    expect(player_answer).not_to be_valid
  end

  it 'is invalid if answer is missing' do
    quiz = FactoryBot.create(:quiz)
    lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
    player = Player.create(name: 'player', hat: 'star', lobby: lobby)

    player_answer = described_class.new(player: player)
    expect(player_answer).not_to be_valid
  end
end
