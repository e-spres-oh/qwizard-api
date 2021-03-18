# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'is valid if quiz, title, time_limit and points present' do
    question = FactoryBot.create(:question)
    answer = described_class.new(title: 'test', question: question)
    expect(answer).to be_valid
  end

  it 'is invalid if title is missing' do
    question = FactoryBot.create(:question)
    answer = described_class.new(question: question)
    expect(answer).not_to be_valid
  end

  it 'is invalid if question is missing' do
    answer = described_class.new(title: 'test')
    expect(answer).not_to be_valid
  end
end
