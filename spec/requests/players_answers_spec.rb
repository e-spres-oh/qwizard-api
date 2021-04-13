# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players Answers API', type: :request do
  describe 'index' do
    subject { get api_v1_players_answers_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current players_answers' do
      FactoryBot.create(:player_answer)
      FactoryBot.create(:player_answer)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(PlayerAnswer.all.as_json)
    end
  end

  describe 'create' do
    let(:player_answer_params) do
      { player_id: FactoryBot.create(:player).id, answer_id: FactoryBot.create(:answer).id }
    end

    subject { post api_v1_players_answers_path, params: { player_answer: player_answer_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a PlayerAnswer model with the request params' do
      subject

      expect(PlayerAnswer.last.player_id).to eq(player_answer_params[:player_id])
      expect(PlayerAnswer.last.answer_id).to eq(player_answer_params[:answer_id])
    end

    it 'responds with the created PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(PlayerAnswer.last.as_json)
    end

    context 'invalid parameters' do
      let(:player_answer_params) do
        { bad_data: 'player_answer bad data' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'player', error: 'blank', message: "must exist" },
                                               { attribute: 'answer', error: 'blank', message: "must exist" }])
      end
    end
  end

  describe 'show' do
    let(:player_answer) { FactoryBot.create(:player_answer) }

    subject { get api_v1_players_answer_path(id: player_answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.as_json)
    end
  end

  describe 'update' do
    let(:player_answer) { FactoryBot.create(:player_answer) }
    let(:player_answer_params) do
      { player_id: FactoryBot.create(:player).id, answer_id: FactoryBot.create(:answer).id }
    end
    subject { put api_v1_players_answer_path(id: player_answer.id), params: { player_answer: player_answer_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the PlayerAnswer attributes' do
      subject

      expect(player_answer.reload.player_id).to eq(player_answer_params[:player_id])
    end

    it 'responds with the updated PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:player_answer) { FactoryBot.create(:player_answer) }

    subject { delete api_v1_players_answer_path(id: player_answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the PlayerAnswer model' do
      subject

      expect { player_answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.as_json)
    end
  end
end
