# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid if username, email and password present' do
    user = described_class.new(username: 'user 1', email: 'random@example.com', password: 'some password')
    expect(user).to be_valid
  end

  it 'is invalid if username missing' do
    user = described_class.new(email: 'random@example.com', password: 'some password')
    expect(user).not_to be_valid
  end

  it 'is invalid if email missing' do
    user = described_class.new(username: 'user 1', password: 'some password')
    expect(user).not_to be_valid
  end

  it 'is invalid if password missing' do
    user = described_class.new(username: 'user 1', email: 'random@example.com')
    expect(user).not_to be_valid
  end
end
