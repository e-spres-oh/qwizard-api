# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if code, current_question_index, status present' do
    quiz = Quiz.create(title: 'Test')
    lobby = described_class.new(code: 'Test', current_question_index: 2, status: 2, quiz: quiz)
    expect(lobby).to be_valid
  end

  it 'is invalid if not binded to quiz' do
    lobby = described_class.new(code: 'Test', current_question_index: 2, status: 2)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if code, current_question_index, status missing' do
    lobby = described_class.new(status: 2)
    expect(lobby).not_to be_valid
  end

end