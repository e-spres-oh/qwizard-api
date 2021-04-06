# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if it belongs to a player and an answer' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = Player.create(
      hat: '1',
      name: 'Alex',
      lobby: lobby
    )
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = Answer.create(
      is_correct: true,
      title: 'test',
      question: question
      )
    player_answer = described_class.new(
      player: player,
      answer: answer
    )
    expect(player_answer).to be_valid
  end

  it 'is not valid if it does not belong to a player' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = Player.create(
      hat: '1',
      name: 'Alex',
      lobby: lobby
    )
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = Answer.create(
      is_correct: true,
      title: 'test',
      question: question
      )
    player_answer = described_class.new(
      answer: answer
    )
    expect(player_answer).not_to be_valid
  end

  it 'is not valid if it does not belong to an answer' do
    quiz = Quiz.create(title: 'test')
    lobby = Lobby.create(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    player = Player.create(
      hat: '1',
      name: 'Alex',
      lobby: lobby
    )
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = Answer.create(
      is_correct: true,
      title: 'test',
      question: question
      )
    player_answer = described_class.new(
      player: player
    )
    expect(player_answer).not_to be_valid
  end
end
