# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid if username, email and password present' do
    user = described_class.new(username: 'username', email: 'username@yahoo.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid if username is missing' do
    user = described_class.new(email: 'username@yahoo.com', password: 'password')
    expect(user).not_to be_valid
  end

  it 'is invalid if email is missing' do
    user = described_class.new(username: 'username', password: 'password')
    expect(user).not_to be_valid
  end

  it 'is invalid if password is missing' do
    user = described_class.new(username: 'username', email: 'username@yahoo.com')
    expect(user).not_to be_valid
  end

end
