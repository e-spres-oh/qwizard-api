# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if is_correct, title present' do
    quiz = Quiz.create(title: 'Test')
    question = Question.create(title: 'test', answer_type: 2, order: 2, points: 2, time_limit: 2, quiz: quiz)
    answer = described_class.new(title: 'Test', is_correct: true, question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if not binded to question' do
    answer = described_class.new(title: 'Test', is_correct: true)
    expect(answer).not_to be_valid
  end

  it 'is invalid if is_correct, title missing' do
    quiz = Quiz.create(title: 'Test')
    question = Question.create(title: 'test', answer_type: 2, order: 2, points: 2, time_limit: 2, quiz: quiz)
    answer = described_class.new
    expect(answer).not_to be_valid
  end

end