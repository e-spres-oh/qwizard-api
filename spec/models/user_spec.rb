# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when username, password and email are present' do
    user = described_class.new(
      username: 'example',
      password: 'password',
      email: 'example@example.com'
      )
    expect(user).to be_valid
  end

  it 'is not valid if username is missing' do
    user = described_class.new(
      password: 'password',
      email: 'example@example.com'
      )
    expect(user).not_to be_valid
  end

  it 'is not valid if password is missing' do
    user = described_class.new(
      username: 'example',
      email: 'example@example.com',
      )
    expect(user).not_to be_valid
  end

  it 'is not valid if email is missing' do
    user = described_class.new(
      username: 'example',
      password: 'password'
      )
    expect(user).not_to be_valid
  end

end
