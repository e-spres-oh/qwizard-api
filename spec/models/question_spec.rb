# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  quiz = Quiz.new(title: 'test')
  answer = Answer.new(title: 'test', is_correct: true)
  it 'is valid if title, points, order, time_limit, answer_type, quiz and answer are present' do
    question = described_class.new(title: 'test', points: 1, order: 1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).to be_valid
  end

  it 'is invalid if title missing' do
    question = described_class.new(points: 1, order: 1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if points missing' do
    question = described_class.new(title: 'test', order: 1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if order missing' do
    question = described_class.new(title: 'test', points: 1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if order is less than zero' do
    question = described_class.new(title: 'test', points: 1, order: -1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if time_limit missing' do
    question = described_class.new(title: 'test', points: 1, order: 1, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if time_limit is zero' do
    question = described_class.new(title: 'test', points: 1, order: 1, time_limit: 0, answer_type: 1, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if answer_type missing' do
    question = described_class.new(title: 'test', points: 1, order: 1, time_limit: 10, quiz: quiz)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if quiz missing' do
    question = described_class.new(title: 'test', points: 1, order: 1, time_limit: 10, answer_type: 1)
    question.answers += [answer]
    expect(question).not_to be_valid
  end

  it 'is invalid if answers missing' do
    question = described_class.new(title: 'test', points: 1, order: 1, time_limit: 10, answer_type: 1, quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if no answer is correct' do
    question = described_class.new(title: 'test', points: 1, order: -1, time_limit: 10, answer_type: 1, quiz: quiz)
    question.answers += [Answer.new(title: 'blah', is_correct: false)]
    expect(question).not_to be_valid
  end
end
