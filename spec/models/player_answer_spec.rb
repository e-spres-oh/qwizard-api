# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if binded to player and answer' do
    quiz = Quiz.create(title: 'Test')
    question = Question.create(title: 'test', answer_type: 2, order: 2, points: 2, time_limit: 2, quiz: quiz)
    answer = Answer.create(title: 'Test', is_correct: true, question: question)
    lobby = Lobby.create(code: 'Test', current_question_index: 2, status: 2, quiz: quiz)
    player = Player.create(hat: 2, name: 'Test', lobby: lobby)
    player_answer = described_class.new(answer: answer, player: player)
    expect(player_answer).to be_valid
  end

end
