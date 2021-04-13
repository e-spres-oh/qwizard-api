<<<<<<< HEAD
require 'rails_helper'

RSpec.describe Answer, type: :model do
  question = Question.new()
  it 'is valid if title, is_correct are present' do
    answer = described_class.new(title: 'test', is_correct: true, question: question)
=======
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if quiz, title, time_limit and points present' do
    question = FactoryBot.create(:question)
    answer = described_class.new(title: 'test', question: question)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(answer).to be_valid
  end

  it 'is invalid if title is missing' do
<<<<<<< HEAD
    answer = described_class.new(is_correct: true, question: question)
    expect(answer).not_to be_valid
  end

  it 'is invalid if is_correct is missing' do
    answer = described_class.new(title: 'test', question: question)
=======
    question = FactoryBot.create(:question)
    answer = described_class.new(question: question)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(answer).not_to be_valid
  end

  it 'is invalid if question is missing' do
<<<<<<< HEAD
    answer = described_class.new(title: 'test', is_correct: true)
=======
    answer = described_class.new(title: 'test')
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(answer).not_to be_valid
  end
end
