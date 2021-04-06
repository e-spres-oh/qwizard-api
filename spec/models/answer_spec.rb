# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if title and question present' do
    quiz = Quiz.new(title: "Test quiz")
    question = Question.new(title: 'question 1', order: 1, answer_type: 1, quiz: quiz)
    answer = described_class.new(title: 'answer 1', question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if question missing' do
    answer = described_class.new
    expect(answer).not_to be_valid
  end

  it 'is invalid if title missing' do
    quiz = Quiz.new(title: "Test quiz")
    question = Question.new(title: 'question 1', order: 1, answer_type: 1, quiz: quiz)
    answer = described_class.new(question: question)
    expect(answer).not_to be_valid
  end
end
