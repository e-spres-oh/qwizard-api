# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if it belongs to a player and an answer' do
    quiz = Quiz.create(title: 'Quiz1')
    question = Question.create(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    answer = Answer.create(title: 'answer1', is_correct: true, question: question)
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = Player.create(name: 'Name', lobby: lobby)
    pa = described_class.new(player: player, answer: answer)
    expect(pa).to be_valid
  end

  it 'is invalid if it does not belong to a player' do
    quiz = Quiz.create(title: 'Quiz1')
    question = Question.create(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    answer = Answer.create(title: 'answer1', is_correct: true, question: question)
    pa = described_class.new(answer: answer)
    expect(pa).not_to be_valid
  end

  it 'is invalid if it does not belong to an answer' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = Lobby.create(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    player = Player.create(name: 'Name', lobby: lobby)
    pa = described_class.new(player: player)
    expect(pa).not_to be_valid
  end

  it 'is invalid if does not belong to player and answer' do
    pa = described_class.new
    expect(pa).not_to be_valid
  end
end