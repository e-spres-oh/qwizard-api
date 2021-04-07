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
    expect(player).not_to be_valid
  end

  it 'is invalid if lobby is missing' do
    player = described_class.new(hat: 1, name: 'test')
    expect(player).not_to be_valid
  end
end
