require 'rails_helper'

RSpec.describe Lobby, type: :model do
  quiz = Quiz.new()
  it 'is valid if quiz, code, current_question_index, status is present' do
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, status: 0, quiz: quiz)
    expect(lobby).to be_valid
  end

  it 'is invalid if code is missing' do
    lobby = described_class.new(current_question_index: 1, status: 0, quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if current_question_index is missing' do
    lobby = described_class.new(code: 'ABC123', status: 0, quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if status is missing' do
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if quiz is missing' do
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, status: 0)
    expect(lobby).not_to be_valid
  end
end
