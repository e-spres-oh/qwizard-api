# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lobbies API', type: :request do
  describe 'index' do
    subject { get api_v1_lobbies_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      FactoryBot.create(:lobby)
      FactoryBot.create(:lobby)
      
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Lobby.all.as_json)
    end
  end

  describe 'create' do
    let(:lobby_params) do
      { code: 'lobby create', status: 'pending', current_question_index: 1, quiz_id: 1 }
    end

    subject { post api_v1_lobbies_path, params: { lobby: lobby_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Lobby model with the request params' do
      subject

      expect(Lobby.last.code).to eq(lobby_params[:code])
    end

    it 'responds with the created Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Lobby.last.as_json)
    end

    context 'invalid parameters' do
      let(:lobby_params) do
        { not_code: 'lobby not code test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'code', error: 'blank', message: "can't be blank" },
                                               { attribute: 'status', error: 'blank', message: "can't be blank" },
                                               { attribute: 'quiz', error: 'blank', message: "must exist" }])
      end
    end
  end

  describe 'show' do
    let(:lobby) { Lobby.create(code: 'foo', status: 'pending', current_question_index: 1, quiz: Quiz.first) }

    subject { get api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json)
    end
  end

  describe 'update' do
    let(:lobby) { Lobby.create(code: 'foo', status: 'pending', current_question_index: 1, quiz: Quiz.first) }
    let(:lobby_params) do
      { code: 'lobby update', status: 'pending', current_question_index: 1, quiz_id: 1 }
    end
    subject { put api_v1_lobby_path(id: lobby.id), params: { lobby: lobby_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Lobby attributes' do
      subject

      expect(lobby.reload.code).to eq('lobby update')
    end

    it 'responds with the updated Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:lobby) { Lobby.create(code: 'foo', status: 'pending', current_question_index: 1, quiz: Quiz.first) }

    subject { delete api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Lobby model' do
      subject

      expect { lobby.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json)
    end
  end
end
