# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LobbiesAPI', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

  describe 'index' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }

    subject { get api_v1_quiz_lobbies_path(quiz_id: quiz.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      foo_lobby = FactoryBot.create(:lobby, quiz: quiz)
      bar_lobby = FactoryBot.create(:lobby, quiz: quiz)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_lobby, bar_lobby].map { |q| q.as_json.merge('quiz_master' => quiz.user.username) })
    end
  end

  describe 'create' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby_params) do
      { status: 'pending', current_question_index: 2 }
    end

    subject { post api_v1_quiz_lobbies_path(quiz_id: quiz.id), params: { lobby: lobby_params } }

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
      expect(lobby.quiz).to eq(quiz)
    end

    it 'responds with the created Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Lobby.last.as_json.merge('quiz_master' => quiz.user.username))
    end

    context 'invalid parameters' do
      let(:lobby_params) do
        { code: 'foo' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'status', error: 'blank', message: 'can\'t be blank' }])
      end
    end
  end

  describe 'show' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }

    subject { get api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'update' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
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
      expect(parsed_response).to eq(lobby.reload.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'destroy' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }

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
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'from_code' do
    let(:lobby) { FactoryBot.create(:lobby) }
    let(:lobby_code) { lobby.code }

    subject { get api_v1_lobby_from_code_path(code: lobby_code) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end

    context 'lobby not found' do
      let(:lobby_code) { 'nonexistent' }

      it 'responds with not found HTTP status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
