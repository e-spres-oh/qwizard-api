# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe 'Users API', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

  describe 'index' do
    subject { get api_v1_users_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current user' do
      foo_user = FactoryBot.create(:user)
      bar_user = FactoryBot.create(:user)

      subject

      parsed_response = JSON.parse(response.body)
      expected = [user, foo_user, bar_user].map { |u| u.slice(:id, :email, :hat, :username, :created_at, :updated_at) }.as_json
      expect(parsed_response).to eq(expected)
    end
  end

  describe 'create' do
    let(:user_params) do
      { username: 'foo', email: 'foo@bar', password: 'bar' }
    end

    subject { post api_v1_users_path, params: { user: user_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a User model with the request params' do
      subject

      expect(User.last.username).to eq(user_params[:username])
      expect(User.last.email).to eq(user_params[:email])
      expect(User.last.password).to eq(user_params[:password])
    end

    it 'responds with the created User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(User.last.slice(:id, :email, :hat, :username, :created_at, :updated_at).as_json)
    end

    context 'invalid parameters' do
      let(:user_params) do
        { username: 'test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'email', error: 'blank', message: "can't be blank" }, { attribute: 'password', error: 'blank', message: "can't be blank" }])
      end
    end
  end

  describe 'show' do
    let(:user) { FactoryBot.create(:user) }

    subject { get api_v1_user_path(id: user.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(user.slice(:id, :email, :hat, :username, :created_at, :updated_at).as_json)
    end
  end

  describe 'update' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) do
      { username: 'test' }
    end
    subject { put api_v1_user_path(id: user.id), params: { user: user_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the User attributes' do
      subject

      expect(user.reload.username).to eq('test')
    end

    it 'responds with the updated User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(user.reload.slice(:id, :email, :hat, :username, :created_at, :updated_at).as_json)
    end
  end

  describe 'destroy' do
    let(:user) { FactoryBot.create(:user) }

    subject { delete api_v1_user_path(id: user.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the User model' do
      subject

      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(user.slice(:id, :email, :hat, :username, :created_at, :updated_at).as_json)
    end
  end

  describe 'recovery_token' do
    let(:user) { FactoryBot.create(:user) }

    subject { post recovery_token_api_v1_users_path, params: { email: user.email } }

    it 'responds with ok HTTP status' do
      subject

      expect(response).to have_http_status(:ok)
    end

    it 'responds with not_found if email is incorrect' do
      user.email = 'no'

      subject

      expect(response).to have_http_status(:not_found)
    end

    it 'responds with not_found if email is missing' do
      subject_missing = post recovery_token_api_v1_users_path
      subject_missing

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'recover_password' do
    let(:user) { FactoryBot.create(:user, token: SecureRandom.hex(16)) }

    subject { post recover_password_api_v1_users_path, params: { token: user.token } }

    before do
      allow(PasswordRecoveryMailer).to receive(:recover_password)
    end

    it 'responds with ok HTTP status' do
      subject

      expect(response).to have_http_status(:ok)
    end

    it 'expects mail to have been sent with new password' do
      subject

      expect(response).to have_http_status(:ok)
      expect(PasswordRecoveryMailer).to have_received(:recover_password).with(user: user.reload)
    end

    it 'responds with not_found if token is incorrect' do
      user.token = 'no'

      subject

      expect(response).to have_http_status(:not_found)
    end

    it 'responds with not_found if token is missing' do
      subject_missing = post recover_password_api_v1_users_path
      subject_missing

      expect(response).to have_http_status(:bad_request)
    end
  end
end