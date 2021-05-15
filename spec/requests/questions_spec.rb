# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'QuestionsAPI', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:quiz) { FactoryBot.create(:quiz, user: user) }

  before { post api_v1_login_path, params: { user: { username: quiz.user.username, password: quiz.user.password } } }

  describe 'index' do
    subject { get api_v1_quiz_questions_path(quiz_id: quiz.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current questions' do
      foo_question = FactoryBot.create(:question, quiz: quiz)
      bar_question = FactoryBot.create(:question, quiz: quiz)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_question, bar_question].map { |q| q.as_json.merge('image_url' => nil) })
    end
  end

  describe 'create' do
    let(:question_params) do
      { title: 'test', time_limit: 30, points: 100, answer_type: 'single', order: 1 }
    end

    subject { post api_v1_quiz_questions_path(quiz_id: quiz.id), params: { question: question_params } }

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
      expect(question.quiz).to eq(quiz)
    end

    it 'responds with the created Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Question.last.as_json.merge('image_url' => nil))
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
        expect(parsed_response).to eq(errors: [{ attribute: 'title', error: 'blank', message: 'can\'t be blank' }])
      end
    end
  end

  describe 'show' do
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

    subject { get api_v1_question_path(id: question.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.as_json.merge('image_url' => nil))
    end
  end

  describe 'update' do
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
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
      expect(parsed_response).to eq(question.reload.as_json.merge('image_url' => nil))
    end
  end

  describe 'destroy' do
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

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
      expect(parsed_response).to eq(question.as_json.merge('image_url' => nil))
    end
  end

  describe 'upload_image' do
    let(:question) { FactoryBot.create(:question, quiz: FactoryBot.create(:quiz, user: user)) }
    let(:image_file) { file_fixture('image.jpg') }
    let(:image_part) do
      Rack::Test::UploadedFile.new(image_file, 'image/jpg')
    end

    subject { post upload_image_api_v1_question_path(id: question.id), params: { image: image_part } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Question attributes' do
      subject

      expect(question.image.attached?).to be_truthy
      expect(question.image.download.size).to eq(image_file.size)
    end

    it 'responds with the updated Question model' do
      subject

      parsed_response = JSON.parse(response.body)
      expected = question.reload.as_json.merge('image_url' => rails_blob_path(question.image))
      expect(parsed_response).to eq(expected)
    end
  end
end
