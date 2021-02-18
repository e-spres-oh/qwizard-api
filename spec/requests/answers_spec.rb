# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AnswersAPI', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

  describe 'index' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

    subject { get api_v1_question_answers_path(question_id: question.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current answers' do
      foo_answer = FactoryBot.create(:answer, question: question)
      bar_answer = FactoryBot.create(:answer, question: question)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_answer, bar_answer].as_json)
    end
  end

  describe 'create' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
    let(:answer_params) do
      { title: 'foo', is_correct: true }
    end

    subject { post api_v1_question_answers_path(question_id: question.id), params: { answer: answer_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Answer model with the request params' do
      subject

      answer = Answer.last

      expect(answer.title).to eq(answer_params[:title])
      expect(answer.is_correct).to eq(answer_params[:is_correct])
      expect(answer.question).to eq(question)
    end

    it 'responds with the created Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Answer.last.as_json)
    end

    context 'invalid parameters' do
      let(:answer_params) do
        { is_correct: true }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'title', error: 'blank', message: 'can\'t be blank' }])
      end
    end
  end

  describe 'show' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
    let(:answer) { FactoryBot.create(:answer, question: question) }

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
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
    let(:answer) { FactoryBot.create(:answer, question: question) }
    let(:answer_params) do
      { is_correct: false }
    end
    subject { put api_v1_answer_path(id: answer.id), params: { answer: answer_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Answer attributes' do
      subject

      expect(answer.reload.is_correct).to eq(false)
    end

    it 'responds with the updated Answer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(answer.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
    let(:answer) { FactoryBot.create(:answer, question: question) }

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
