# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  describe 'index' do
    subject { get api_v1_questions_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current questions' do
      FactoryBot.create(:question)
      FactoryBot.create(:question)
      
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Question.all.as_json)
    end
  end

  describe 'create' do
    let(:question_params) do
      { title: 'foo', order: 1, time_limit: 30, points: 1, answer_type: 'single', quiz_id: 1 }
    end

    subject { post api_v1_questions_path, params: { question: question_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Question model with the request params' do
      subject

      expect(Question.last.title).to eq(question_params[:title])
    end

    it 'responds with the created Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Question.last.as_json)
    end

    context 'invalid parameters' do
      let(:question_params) do
        { not_title: 'question not code test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'title', error: 'blank', message: "can't be blank" },
                                               { attribute: 'time_limit', error: 'blank', message: "can't be blank" },
                                               { attribute: 'points', error: 'blank', message: "can't be blank" },
                                               { attribute: 'answer_type', error: 'blank', message: "can't be blank" },
                                               { attribute: 'order', error: 'blank', message: "can't be blank" },
                                               { attribute: 'quiz', error: 'blank', message: "must exist" }])
      end
    end
  end

  describe 'show' do
    let(:question) {
      Question.create(title: 'foo', order: 1, time_limit: 30, points: 1, answer_type: 'single', quiz: Quiz.first)
    }

    subject { get api_v1_question_path(id: question.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.as_json)
    end
  end

  describe 'update' do
    let(:question) {
      Question.create(title: 'foo', order: 1, time_limit: 30, points: 1, answer_type: 'single', quiz: Quiz.first)
    }
    let(:question_params) do
      { title: 'new', order: 3, time_limit: 50, points: 18, answer_type: 'single', quiz_id: 1 }
    end
    subject { put api_v1_question_path(id: question.id), params: { question: question_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Question attributes' do
      subject

      expect(question.reload.title).to eq('new')
    end

    it 'responds with the updated Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:question) {
      Question.create(title: 'foo', order: 1, time_limit: 30, points: 1, answer_type: 'single', quiz: Quiz.first)
    }

    subject { delete api_v1_question_path(id: question.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Question model' do
      subject

      expect { question.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.as_json)
    end
  end
end
