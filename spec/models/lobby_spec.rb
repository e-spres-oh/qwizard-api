# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if quiz, code and status present' do
    quiz = Quiz.create(title: 'quiz')
    lobby = described_class.new(code: 'foo', status: 'pending', quiz: quiz)
    expect(lobby).to be_valid
  end

  it 'is invalid if code is missing' do
    quiz = Quiz.create(title: 'quiz')
    lobby = described_class.new(status: 'pending', quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if status is missing' do
    quiz = Quiz.create(title: 'quiz')
    lobby = described_class.new(code: 'foo', quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if quiz is missing' do
    lobby = described_class.new(code: 'foo', status: 'pending')
    expect(lobby).not_to be_valid
  end
end
