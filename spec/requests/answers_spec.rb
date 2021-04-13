# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  describe 'index' do
    subject { get api_v1_answers_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current answers' do
      FactoryBot.create(:answer)
      FactoryBot.create(:answer)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Answer.all.as_json)
    end
  end

  describe 'create' do
    let(:answer_params) do
      { title: 'new answer', is_correct: true, question_id: FactoryBot.create(:question).id }
    end

    subject { post api_v1_answers_path, params: { answer: answer_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Answer model with the request params' do
      subject

      expect(Answer.last.title).to eq(answer_params[:title])
    end

    it 'responds with the created Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Answer.last.as_json)
    end

    context 'invalid parameters' do
      let(:answer_params) do
        { not_title: 'answer not title test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'title', error: 'blank', message: "can't be blank" },
                                               { attribute: 'question', error: 'blank', message: "must exist" }])
      end
    end
  end

  describe 'show' do
    let(:answer) {
      Answer.create(title: 'Answer title', is_correct: true, question: Question.first)
    }

    subject { get api_v1_answer_path(id: answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(answer.as_json)
    end
  end

  describe 'update' do
    let(:answer) {
      Answer.create(title: 'Answer title', is_correct: true, question: Question.first)
    }
    let(:answer_params) do
      { title: 'Answer title', is_correct: true, question_id: FactoryBot.create(:question).id }
    end
    subject { put api_v1_answer_path(id: answer.id), params: { answer: answer_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Answer attributes' do
      subject

      expect(answer.reload.title).to eq('Answer title')
    end

    it 'responds with the updated Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(answer.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:answer) {
      Answer.create(title: 'Answer title', is_correct: true, question: Question.first)
    }

    subject { delete api_v1_answer_path(id: answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Answer model' do
      subject

      expect { answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(answer.as_json)
    end
  end
end
