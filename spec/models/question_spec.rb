# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is valid if title, time_limit and points present' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1, answer_type: 'single')
    expect(question).to be_valid
  end

  it 'is invalid if title is missing' do
    question = described_class.new(time_limit: 30, points: 100, order: 1, answer_type: 'single')
    expect(question).not_to be_valid
  end

  it 'is invalid if time_limit is missing' do
    question = described_class.new(title: 'test', points: 100, order: 1, answer_type: 'single')
    expect(question).not_to be_valid
  end

  it 'is invalid if points is missing' do
    question = described_class.new(title: 'test', time_limit: 30, order: 1, answer_type: 'single')
    expect(question).not_to be_valid
  end

  it 'is invalid if order is missing' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, answer_type: 'single')
    expect(question).not_to be_valid
  end

  it 'is invalid if answer_type is missing' do
    question = described_class.new(title: 'test', time_limit: 30, points: 100, order: 1)
    expect(question).not_to be_valid
  end
end
