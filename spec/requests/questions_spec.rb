# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  describe 'given we call index' do
    subject { get api_v1_questions_path }

    it 'should respond with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'should respond with the current questions' do
      foo_question = FactoryBot.create(:question);
      bar_question = FactoryBot.create(:question);

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_question, bar_question].as_json)
    end
  end

  describe 'create' do
    let(:question_params) do
      { title: 'Nice Question is this what we looking for ?', order: 150, time_limit: 99, points: 40, answer_type: 'single', quiz_id: Quiz.first.id }
    end
    subject { post api_v1_questions_path, params: { question: question_params } }

    it 'should respond with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'should create a Question model with the request params' do
      subject

      expect(Question.last.title).to eq(question_params[:title])
    end

    it 'should respond with the created Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Question.last.as_json)
    end

    context 'invalid parameters' do
      let(:question_params) do
        { wrong_field: 'Nice Question is this what we looking for ?' }
      end

      it 'should respond with unprocessable_entity HTTP status' do
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
                                               { attribute: 'quiz', error: 'blank', message: "must exist" } ])
      end
    end
  end

  describe 'show' do
    let(:question) { FactoryBot.create(:question) }

    subject { get api_v1_question_path(id: question.id) }

    it 'should respond with a successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'should respond with the requested Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.as_json)
    end
  end

  describe 'update' do
    let(:question) { FactoryBot.create(:question) }
    let(:question_params) do
      { title: 'Nice Question is this what we looking for ?', order: 150, time_limit: 99, points: 40, answer_type: 'single', quiz_id: Quiz.first.id }
    end
    subject { put api_v1_question_path(id: question.id), params: { question: question_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Question attributes' do
      subject

      expect(question.reload.title).to eq('Nice Question is this what we looking for ?')
    end

    it 'responds with the updated Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:question) { FactoryBot.create(:question) }

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
