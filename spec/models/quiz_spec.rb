# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz, type: :model do
  it 'is valid if title and user present' do
    user = FactoryBot.create(:user)
    quiz = described_class.new(title: 'test', user: user)
    expect(quiz).to be_valid
  end

  it 'is invalid if title missing' do
    user = FactoryBot.create(:user)
    quiz = described_class.new(user: user)
    expect(quiz).not_to be_valid
  end

  it 'is invalid if user missing' do
    quiz = described_class.new(title: 'test')
    expect(quiz).not_to be_valid
  end
end
