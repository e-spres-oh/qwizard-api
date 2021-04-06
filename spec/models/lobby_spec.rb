# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if all attributes are present and belongs to a quiz' do
    quiz = Quiz.create(title: 'test')
    lobby = described_class.new(
      code: 'test',
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    expect(lobby).to be_valid
  end

  it 'is not valid if code is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = described_class.new(
      current_question_index: '1',
      status: '1',
      quiz: quiz
    )
    expect(lobby).not_to be_valid
  end

  it 'is not valid if current_question_index is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = described_class.new(
      code: 'test',
      status: '1',
      quiz: quiz
    )
    expect(lobby).not_to be_valid
  end

  it 'is not valid if status is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = described_class.new(
      code: 'test',
      current_question_index: '1',
      quiz: quiz
    )
    expect(lobby).not_to be_valid
  end

  it 'is not valid if quiz is not present' do
    quiz = Quiz.create(title: 'test')
    lobby = described_class.new(
      code: 'test',
      current_question_index: '1',
      status: '1',
    )
    expect(lobby).not_to be_valid
  end
end
