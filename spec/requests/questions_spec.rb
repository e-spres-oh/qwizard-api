# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'QuestionsAPI', type: :request do
  describe 'index' do
    subject { get api_v1_questions_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current questions' do
      quiz = Quiz.create(title: 'quiz')
      foo_question = Question.create(title: 'foo', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz)
      bar_question = Question.create(title: 'bar', time_limit: 30, points: 100, answer_type: 'single', order: 2, quiz: quiz)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_question, bar_question].as_json)
    end
  end

  describe 'create' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question_params) do
      { title: 'test', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz_id: quiz.id }
    end

    subject { post api_v1_questions_path, params: { question: question_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Question model with the request params' do
      subject

      question = Question.last

      expect(question.title).to eq(question_params[:title])
      expect(question.time_limit).to eq(question_params[:time_limit])
      expect(question.points).to eq(question_params[:points])
      expect(question.quiz).to eq(Quiz.find(question_params[:quiz_id]))
    end

    it 'responds with the created Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Question.last.as_json)
    end

    context 'invalid parameters' do
      let(:question_params) do
        { time_limit: 30, points: 100, answer_type: 'single', order: 1 }
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
            { attribute: 'title', error: 'blank', message: 'can\'t be blank' },
            { attribute: 'quiz', error: 'blank', message: 'must exist' }
          ]
        )
      end
    end
  end

  describe 'show' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'foo', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }

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
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'foo', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }
    let(:question_params) do
      { time_limit: 60 }
    end
    subject { put api_v1_question_path(id: question.id), params: { question: question_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Question attributes' do
      subject

      expect(question.reload.time_limit).to eq(60)
    end

    it 'responds with the updated Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'foo', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }

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
