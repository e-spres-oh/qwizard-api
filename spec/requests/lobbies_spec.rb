# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LobbiesAPI', type: :request do
  describe 'index' do
    subject { get api_v1_lobbies_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      foo_lobby = FactoryBot.create(:lobby)
      bar_lobby = FactoryBot.create(:lobby)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_lobby, bar_lobby].as_json)
    end
  end

  describe 'create' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby_params) do
      { status: 'pending', quiz_id: quiz.id, current_question_index: 2 }
    end

    subject { post api_v1_lobbies_path, params: { lobby: lobby_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Lobby model with the request params' do
      subject

      lobby = Lobby.last

      expect(lobby.code).to be_present
      expect(lobby.status).to eq(lobby_params[:status])
      expect(lobby.current_question_index).to eq(2)
      expect(lobby.quiz).to eq(Quiz.find(lobby_params[:quiz_id]))
    end

    it 'responds with the created Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Lobby.last.as_json)
    end

    context 'invalid parameters' do
      let(:lobby_params) do
        { status: 'pending' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'quiz', error: 'blank', message: 'must exist' }])
      end
    end
  end

  describe 'show' do
    let(:lobby) { FactoryBot.create(:lobby) }

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
    let(:lobby) { FactoryBot.create(:lobby) }
    let(:lobby_params) do
      { status: 'in_progress' }
    end
    subject { put api_v1_lobby_path(id: lobby.id), params: { lobby: lobby_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Lobby attributes' do
      subject

      expect(lobby.reload.status).to eq('in_progress')
    end

    it 'responds with the updated Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:lobby) { FactoryBot.create(:lobby) }

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