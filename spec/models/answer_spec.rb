# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if title is present and it belongs to a question' do
    quiz = Quiz.create(title: 'Quiz1')
    question = Question.create(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    answer = described_class.new(title: 'answer1', is_correct: true, question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if it does not belong to a question' do
    answer = described_class.new(title: 'answer1', is_correct: true)
    expect(answer).not_to be_valid
  end

  it 'is invalid if title missing' do
    quiz = Quiz.create(title: 'Quiz1')
    question = Question.create(title: 'question1', answer_type: 1, order: 2, points: 20, time_limit: 30, quiz: quiz)
    answer = described_class.new(is_correct: true, question: question)
    expect(answer).not_to be_valid
  end
end