# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyLobbyEndJob, type: :job do
  describe 'perform' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }

    before do
      allow(Pusher).to receive(:trigger)
    end

    subject { described_class.perform_now(lobby_id: lobby.id) }

    it 'triggers a LOBBY_END Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::LOBBY_END, {})
    end

    it 'marks the Lobby as finished' do
      subject

      expect(lobby.reload.status).to eq('finished')
    end
  end
end
