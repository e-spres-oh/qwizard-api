# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if player and answer present' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = Lobby.new(code: 1, quiz: quiz)
    question = Question.new(title: 'question 1', order: 1, answer_type: 1, quiz: quiz)
    player = Player.new(name: 'player 1', hat: 1, lobby: lobby)
    answer = Answer.new(title: 'answer 1', question: question)
    player_answer = described_class.new(player: player, answer: answer)
    expect(player_answer).to be_valid
  end

  it 'is invalid if player missing' do
    quiz = Quiz.new(title: "Test quiz")
    question = Question.new(title: 'question 1', order: 1, answer_type: 1, quiz: quiz)
    answer = Answer.new(title: 'answer 1', question: question)
    player_answer = described_class.new(answer: answer)
    expect(player_answer).not_to be_valid
  end


  it 'is invalid if player missing' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = Lobby.new(code: 1, quiz: quiz)
    player = Player.new(name: 'player 1', hat: 1, lobby: lobby)
    player_answer = described_class.new(player: player)
    expect(player_answer).not_to be_valid
  end

  it 'is invalid if player ans answer missing' do
    player_answer = described_class.new
    expect(player_answer).not_to be_valid
  end
end
