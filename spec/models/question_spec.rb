# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is valid if title, answer type, order, points and time limit present' do
    quiz = Quiz.create(title: 'Test')
    question = described_class.new(title: 'test', answer_type: 2, order: 2, points: 2, time_limit: 2, quiz: quiz)
    expect(question).to be_valid
  end

  it 'is invalid if not binded to quiz' do
    question = described_class.new(title: 'test', answer_type: 2, order: 2, points: 2, time_limit: 2)
    expect(question).not_to be_valid
  end

  it 'is invalid if title, answer type, order, points and time limit missing' do
    question = described_class.new
    expect(question).not_to be_valid
  end

  it 'is invalid if title missing' do
    question = described_class.new(answer_type: 2, order: 2, points: 2, time_limit: 2)
    expect(question).not_to be_valid
  end
end