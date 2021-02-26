# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Quizzes API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

  describe 'index' do
    subject { get api_v1_quizzes_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current quizzes' do
      foo_quiz = FactoryBot.create(:quiz, user: user)
      bar_quiz = FactoryBot.create(:quiz, user: user)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_quiz, bar_quiz].map { |q| q.as_json.merge('image_url' => nil) })
    end
  end

  describe 'create' do
    let(:quiz_params) do
      { title: 'test' }
    end

    subject { post api_v1_quizzes_path, params: { quiz: quiz_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Quiz model with the request params' do
      subject

      expect(Quiz.last.title).to eq(quiz_params[:title])
    end

    it 'responds with the created Quiz model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Quiz.last.as_json.merge('image_url' => nil))
    end

    context 'invalid parameters' do
      let(:quiz_params) do
        { not_title: 'test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'title', error: 'blank', message: "can't be blank" }])
      end
    end
  end

  describe 'upload_image' do
    let(:quiz) { Quiz.create(title: 'foo', user: user) }
    let(:image_file) { file_fixture('image.jpg') }
    let(:image_part) do
      Rack::Test::UploadedFile.new(image_file, 'image/jpg')
    end
    subject { post upload_image_api_v1_quiz_path(id: quiz.id), params: { image: image_part } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Quiz attributes' do
      subject

      expect(quiz.image.attached?).to be_truthy
      expect(quiz.image.download.size).to eq(image_file.size)
    end

    it 'responds with the updated Quiz model' do
      subject

      parsed_response = JSON.parse(response.body)
      expected = quiz.reload.as_json.merge('image_url' => rails_blob_path(quiz.image))
      expect(parsed_response).to eq(expected)
    end
  end

  describe 'show' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }

    subject { get api_v1_quiz_path(id: quiz.id) }

    context 'not authenticated' do
      before { delete api_v1_logout_path }

      it 'responds with successful HTTP status' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'responds with the requested Quiz model' do
        subject

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(quiz.as_json.merge('image_url' => nil))
      end
    end
  end

  describe 'update' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:quiz_params) do
      { title: 'test' }
    end
    subject { put api_v1_quiz_path(id: quiz.id), params: { quiz: quiz_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Quiz attributes' do
      subject

      expect(quiz.reload.title).to eq('test')
    end

    it 'responds with the updated Quiz model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(quiz.reload.as_json.merge('image_url' => nil))
    end
  end

  describe 'destroy' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }

    subject { delete api_v1_quiz_path(id: quiz.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Quiz model' do
      subject

      expect { quiz.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Quiz model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(quiz.as_json.merge('image_url' => nil))
    end
  end
end