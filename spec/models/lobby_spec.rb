# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if quiz and code present' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = described_class.new(code: 1, quiz: quiz)
    expect(lobby).to be_valid
  end

  it 'is invalid if code missing' do
    quiz = Quiz.new(title: "Test quiz")
    lobby = described_class.new(quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if quiz missing' do
    lobby = described_class.new(code: 1)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if quiz and code missing' do
    lobby = described_class.new
    expect(lobby).not_to be_valid
  end
end
