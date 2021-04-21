# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  it 'is valid if player and answer are present' do
    player = FactoryBot.create(:player)
    answer = FactoryBot.create(:answer)

    player_answer = described_class.new(player: player, answer: answer)
    expect(player_answer).to be_valid
  end

  it 'is invalid if player is missing' do
    answer = FactoryBot.create(:answer)

    player_answer = described_class.new(answer: answer)
    expect(player_answer).not_to be_valid
  end

  it 'is invalid if answer is missing' do
    player = FactoryBot.create(:player)

    player_answer = described_class.new(player: player)
    expect(player_answer).not_to be_valid
  end
end
