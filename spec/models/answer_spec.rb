require 'rails_helper'

RSpec.describe Answer, type: :model do
  question = Question.new()
  it 'is valid if title, is_correct are present' do
    answer = described_class.new(title: 'test', is_correct: true, question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if title is missing' do
    answer = described_class.new(is_correct: true, question: question)
    expect(answer).not_to be_valid
  end

  it 'is invalid if is_correct is missing' do
    answer = described_class.new(title: 'test', question: question)
    expect(answer).not_to be_valid
  end

  it 'is invalid if question is missing' do
    answer = described_class.new(title: 'test', is_correct: true)
    expect(answer).not_to be_valid
  end
end
