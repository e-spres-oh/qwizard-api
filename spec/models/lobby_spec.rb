# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if code, current_question_index, status are present and it belongs to a quiz' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = described_class.new(code: 'lobby code', current_question_index: 1, status: 2, quiz: quiz)
    expect(lobby).to be_valid
  end

  it 'is invalid if it does not belong to a quiz' do
    lobby = described_class.new(code: 'lobby code', current_question_index: 1, status: 2)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if code missing' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = described_class.new(current_question_index: 1, status: 2, quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid code, current_question_index, status are missing' do
    quiz = Quiz.create(title: 'Quiz1')
    lobby = described_class.new(quiz: quiz)
    expect(lobby).not_to be_valid
  end
end
