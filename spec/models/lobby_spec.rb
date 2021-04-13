<<<<<<< HEAD
require 'rails_helper'

RSpec.describe Lobby, type: :model do
  quiz = Quiz.new()
  it 'is valid if quiz, code, current_question_index, status is present' do
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, status: 0, quiz: quiz)
=======
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lobby, type: :model do
  it 'is valid if quiz, code and status present' do
    quiz = FactoryBot.create(:quiz)
    lobby = described_class.new(code: 'foo', status: 'pending', quiz: quiz)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(lobby).to be_valid
  end

  it 'is invalid if code is missing' do
<<<<<<< HEAD
    lobby = described_class.new(current_question_index: 1, status: 0, quiz: quiz)
    expect(lobby).not_to be_valid
  end

  it 'is invalid if current_question_index is missing' do
    lobby = described_class.new(code: 'ABC123', status: 0, quiz: quiz)
=======
    quiz = FactoryBot.create(:quiz)
    lobby = described_class.new(status: 'pending', quiz: quiz)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(lobby).not_to be_valid
  end

  it 'is invalid if status is missing' do
<<<<<<< HEAD
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, quiz: quiz)
=======
    quiz = FactoryBot.create(:quiz)
    lobby = described_class.new(code: 'foo', quiz: quiz)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(lobby).not_to be_valid
  end

  it 'is invalid if quiz is missing' do
<<<<<<< HEAD
    lobby = described_class.new(code: 'ABC123', current_question_index: 1, status: 0)
=======
    lobby = described_class.new(code: 'foo', status: 'pending')
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(lobby).not_to be_valid
  end
end
