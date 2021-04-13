# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
<<<<<<< HEAD
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
=======
  let(:quiz) { FactoryBot.create(:quiz) }
  it 'is valid if quiz, title, time_limit and points present' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)
    expect(question).to be_valid
  end

  it 'is invalid if title is missing' do
    question = described_class.new(time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if time_limit is missing' do
    question = described_class.new(title: 'test', points: 100, order: 1, answer_type: 'single', quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if points is missing' do
    question = described_class.new(title: 'test', time_limit: 30, order: 1, answer_type: 'single', quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if order is missing' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, answer_type: 'single', quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if answer_type is missing' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1, quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if quiz is missing' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1, answer_type: 'single')
    expect(question).not_to be_valid
  end

  it 'is invalid if order is already taken' do
    described_class.create(title: 'test', time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)

    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1, answer_type: 'single', quiz: quiz)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(question).not_to be_valid
  end
end
