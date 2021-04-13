<<<<<<< HEAD
require 'rails_helper'

RSpec.describe Player, type: :model do
  lobby = Lobby.new()
  it 'is valid if hat,name,lobby are present' do
    player = described_class.new(hat: 1, name: 'test', lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if hat is missing' do
    player = described_class.new(name: 'test', lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if name is missing' do
    player = described_class.new(hat: 1, lobby: lobby)
=======
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if lobby and name present' do
    quiz = FactoryBot.create(:quiz)
    lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
    player = described_class.new(name: 'foo', hat: 'star', lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if name is missing' do
    quiz = FactoryBot.create(:quiz)
    lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
    player = described_class.new(hat: 'star', lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if hat is missing' do
    quiz = FactoryBot.create(:quiz)
    lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
    player = described_class.new(name: 'foo', lobby: lobby)
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(player).not_to be_valid
  end

  it 'is invalid if lobby is missing' do
<<<<<<< HEAD
    player = described_class.new(hat: 1, name: 'test')
=======
    player = described_class.new(name: 'foo', hat: 'star')
>>>>>>> 0f19b0f11d64307ec70676a0316057e687aa7c89
    expect(player).not_to be_valid
  end
end
