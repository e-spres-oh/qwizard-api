require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
  answer = Answer.new()
  player = Player.new()
  it 'is valid if answer,player are present' do
    playerAnswer = described_class.new(answer: answer, player: player)
    expect(playerAnswer).to be_valid
  end

  it 'is invalid if answer is missing' do
    playerAnswer = described_class.new(player: player)
    expect(playerAnswer).not_to be_valid
  end

  it 'is invalid if player is missing' do
    playerAnswer = described_class.new(answer: answer)
    expect(playerAnswer).not_to be_valid
  end
end
