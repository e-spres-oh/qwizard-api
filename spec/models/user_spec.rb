# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid if username, email and password are present' do
    user =  described_class.new(username: 'name.surename', email: 'name@example.com', password: 'qwerty')
    expect(user).to be_valid
  end

  it 'is valid if it has username, email, password and hat' do
    user =  described_class.new(username: 'name.surename', email: 'name@example.com', password: 'qwerty', hat: 1)
    expect(user).to be_valid
  end

  it 'is invalid if username missing' do
    user =  described_class.new(email: 'name@example.com', password: 'qwerty')
    expect(user).not_to be_valid
  end

  it 'is invalid if email missing' do
    user =  described_class.new(username: 'name.surename', password: 'qwerty')
    expect(user).not_to be_valid
  end

  it 'is invalid if password missing' do
    user =  described_class.new(username: 'name.surename', email: 'name@example.com')
    expect(user).not_to be_valid
  end
end
