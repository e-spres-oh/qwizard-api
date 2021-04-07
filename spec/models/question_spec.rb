# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is valid if title, answer_type, order, points, time limit are present and it belongs to a quiz' do
    quiz = Quiz.create(title: 'Quiz1')
    question = described_class.new(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    expect(question).to be_valid
  end

  it 'is invalid if it does not belong to a quiz' do
    question = described_class.new(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30)
    expect(question).not_to be_valid
  end

  it 'is invalid if title missing' do
    quiz = Quiz.create(title: 'Quiz1')
    question = described_class.new(answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if title, answer_type, order, points, time_limit are missing' do
    quiz = Quiz.create(title: 'Quiz1')
    question = described_class.new(quiz: quiz)
    expect(question).not_to be_valid
  end
end
