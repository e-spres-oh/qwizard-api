# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid if lobby and name present' do
    lobby = FactoryBot.create(:lobby)

    player = described_class.new(name: 'foo', hat: 'star', lobby: lobby)
    expect(player).to be_valid
  end

  it 'is invalid if name is missing' do
    lobby = FactoryBot.create(:lobby)

    player = described_class.new(hat: 'star', lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if hat is missing' do
    lobby = FactoryBot.create(:lobby)

    player = described_class.new(name: 'foo', lobby: lobby)
    expect(player).not_to be_valid
  end

  it 'is invalid if lobby is missing' do
    player = described_class.new(name: 'foo', hat: 'star')
    expect(player).not_to be_valid
  end
end
