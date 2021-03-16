# frozen_string_literal: true

require 'rails_helper'

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

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'adds a recovery token to the User model' do
      user.update!(recovery_token: nil)

      subject

      expect(user.reload.recovery_token).not_to be_nil
    end

    it 'sends a recovery_token email to the User' do
      mail = double(:mail)
      expect(PasswordRecoveryMailer).to receive(:with).with(user: user).and_return(mail)
      expect(mail).to receive(:recovery_token).and_return(mail)
      expect(mail).to receive(:deliver_later)

      subject
    end
  end

  describe 'recovery_token' do
    let(:user) { FactoryBot.create(:user) }

    subject { post recovery_token_api_v1_users_path, params: { email: user.email } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'adds a recovery token to the User model' do
      user.update!(recovery_token: nil)

      subject

      expect(user.reload.recovery_token).not_to be_nil
    end

    it 'sends a recovery_token email to the User' do
      mail = double(:mail)
      expect(PasswordRecoveryMailer).to receive(:with).with(user: user).and_return(mail)
      expect(mail).to receive(:recovery_token).and_return(mail)
      expect(mail).to receive(:deliver_later)

      subject
    end
  end

  describe 'recover_password' do
    let(:user) { FactoryBot.create(:user, recovery_token: 'foo') }

    subject { post recover_password_api_v1_users_path, params: { recovery_token: user.recovery_token } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'resets the User model password' do
      old_password = user.password

      subject

      expect(user.reload.password).not_to eq(old_password)
    end

    it 'sends a recover_password email to the User' do
      mail = double(:mail)
      expect(PasswordRecoveryMailer).to receive(:with).with(user: user).and_return(mail)
      expect(mail).to receive(:recover_password).and_return(mail)
      expect(mail).to receive(:deliver_later)

      subject
    end
  end
end