# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Question, type: :model do
  it 'is valid if quiz, title, order and answer_type present' do
    quiz = Quiz.new(title: "Test quiz")
    question = described_class.new(title: 'question 1', order: 1, answer_type: 1, quiz: quiz)
    expect(question).to be_valid
  end

  it 'is invalid if quiz missing' do
    question = described_class.new(title: 'question 1', order: 1, answer_type: 1)
    expect(question).not_to be_valid
  end

  it 'is invalid if quiz, title, order and answer_type missing' do
    question = described_class.new
    expect(question).not_to be_valid
  end

  it 'is invalid if title missing' do
    quiz = Quiz.new(title: "Test quiz")
    question = described_class.new(order: 1, answer_type: 1, quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if order missing' do
    quiz = Quiz.new(title: "Test quiz")
    question = described_class.new(title: "not valid", answer_type: 1, quiz: quiz)
    expect(question).not_to be_valid
  end

  it 'is invalid if answer_type missing' do
    quiz = Quiz.new(title: "Test quiz")
    question = described_class.new(order: 1, title: "not valid again", quiz: quiz)
    expect(question).not_to be_valid
  end
end
