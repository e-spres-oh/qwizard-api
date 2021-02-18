# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid if username, email and password present' do
    user = described_class.new(username: 'foo', email: 'foo@bar', password: 'bar')
    expect(user).to be_valid
  end

  it 'is invalid if username missing' do
    user = described_class.new(email: 'foo@bar', password: 'bar')
    expect(user).not_to be_valid
  end

  it 'is invalid if email missing' do
    user = described_class.new(username: 'foo', password: 'bar')
    expect(user).not_to be_valid
  end

  it 'is invalid if password missing' do
    user = described_class.new(username: 'foo', email: 'foo@bar')
    expect(user).not_to be_valid
  end
end
