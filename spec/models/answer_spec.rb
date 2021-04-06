# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if all attributes are present and belongs to a question' do
    quiz = Quiz.create(title: 'test')
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = described_class.new(
      is_correct: true,
      title: 'test',
      question: question
      )
    expect(answer).to be_valid
  end

  it 'check if is_correct accepts false as value' do
    quiz = Quiz.create(title: 'test')
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = described_class.new(
      is_correct: false,
      title: 'test',
      question: question
      )
    expect(answer).to be_valid
  end

  it 'is not valid if is_correct is not present' do
    quiz = Quiz.create(title: 'test')
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = described_class.new(
      title: 'test',
      question: question
      )
    expect(answer).not_to be_valid
  end

  it 'is not valid if title is not present' do
    quiz = Quiz.create(title: 'test')
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = described_class.new(
      is_correct: true,
      question: question
      )
    expect(answer).not_to be_valid
  end

  it 'is not valid if question is not present' do
    quiz = Quiz.create(title: 'test')
    question = Question.create(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz: quiz
      )
    answer = described_class.new(
      is_correct: true,
      title: 'test'
      )
    expect(answer).not_to be_valid
  end
end
