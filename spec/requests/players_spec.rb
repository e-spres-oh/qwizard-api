# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlayersAPI', type: :request do
  describe 'index' do
    subject { get api_v1_players_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      foo_player = FactoryBot.create(:player)
      bar_player = FactoryBot.create(:player)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_player, bar_player].as_json)
    end
  end

  describe 'create' do
    let(:lobby) { FactoryBot.create(:lobby) }
    let(:player_params) do
      { name: 'foo', hat: 'star', lobby_id: lobby.id }
    end

    subject { post api_v1_players_path, params: { player: player_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Player model with the request params' do
      subject

      player = Player.last

      expect(player.name).to eq(player_params[:name])
      expect(player.hat).to eq(player_params[:hat])
      expect(player.lobby).to eq(Lobby.find(player_params[:lobby_id]))
    end

    it 'responds with the created Player model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Player.last.as_json)
    end

    context 'invalid parameters' do
      let(:player_params) do
        { name: 'foo' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(
          errors: [
            { attribute: 'hat', error: 'blank', message: 'can\'t be blank' },
            { attribute: 'lobby', error: 'blank', message: 'must exist' }
          ]
        )
      end
    end
  end

  describe 'show' do
    let(:player) { FactoryBot.create(:player) }

    subject { get api_v1_player_path(id: player.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Player model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player.as_json)
    end
  end

  describe 'update' do
    let(:player) { FactoryBot.create(:player) }
    let(:player_params) do
      { hat: 'earth' }
    end
    subject { put api_v1_player_path(id: player.id), params: { player: player_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Player attributes' do
      subject

      expect(player.reload.hat).to eq('earth')
    end

    it 'responds with the updated Player model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:player) { FactoryBot.create(:player) }

    subject { delete api_v1_player_path(id: player.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Player model' do
      subject

      expect { player.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Player model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player.as_json)
    end
  end
end
