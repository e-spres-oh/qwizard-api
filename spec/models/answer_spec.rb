# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if quiz, title, time_limit and points present' do
    quiz = Quiz.create(title: 'quiz')
    question = Question.create(title: 'question', time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)
    answer = described_class.new(title: 'test', question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if title is missing' do
    quiz = Quiz.create(title: 'quiz')
    question = Question.create(title: 'question', time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)
    answer = described_class.new(question: question)
    expect(answer).not_to be_valid
  end

  it 'is invalid if question is missing' do
    answer = described_class.new(title: 'test')
    expect(answer).not_to be_valid
  end
end
