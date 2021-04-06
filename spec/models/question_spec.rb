# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is valid if all attributes are present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz_id: '1'
      )
    expect(question).to be_valid
  end

  it 'is not valid if answer_type is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz_id: '1'
      )
    expect(question).not_to be_valid
  end

  it 'is not valid if order is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      points: '1',
      time_limit: '1',
      title: 'test',
      quiz_id: '1'
      )
    expect(question).not_to be_valid
  end

  it 'is not valid if points is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      order: '1',
      time_limit: '1',
      title: 'test',
      quiz_id: '1'
      )
    expect(question).not_to be_valid
  end

  it 'is not valid if time_limit is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      order: '1',
      points: '1',
      title: 'test',
      quiz_id: '1'
      )
    expect(question).not_to be_valid
  end

  it 'is not valid if title is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      quiz_id: '1'
      )
    expect(question).not_to be_valid
  end

  it 'is not valid if quiz_id is not present' do
    quiz = Quiz.create(title: 'test')
    question = described_class.new(
      answer_type: '1',
      order: '1',
      points: '1',
      time_limit: '1',
      title: 'test'
      )
    expect(question).not_to be_valid
  end
end