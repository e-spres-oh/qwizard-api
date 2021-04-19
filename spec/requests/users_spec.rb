# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'index' do
    subject { get api_v1_users_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end
  end

  describe 'create' do
    let(:user_params) do
      { username: 'test', email: 'random@example.com', password: 'some password' }
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

    context 'invalid parameters' do
      let(:user_params) do
        { not_username: 'test' }
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
                                       { attribute: 'username', error: 'blank', message: "can't be blank" },
                                       { attribute: 'email', error: 'blank', message: "can't be blank" },
                                       { attribute: 'password', error: 'blank', message: "can't be blank" }
                                     ]
                                   )
      end
    end
  end

  describe 'show' do
    let(:user) { FactoryBot.create(:user) }

    subject { get api_v1_user_path(id: user.id) }

    context 'not authenticated' do
      before { delete api_v1_logout_path }

      it 'responds with successful HTTP status' do
        subject

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'update' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) do
      { username: 'test', email: 'random@example.com', password: 'some password' }
    end
    subject { put api_v1_user_path(id: user.id), params: { user: user_params } }
    before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the User attributes' do
      subject

      expect(user.reload.username).to eq('test')
    end
  end

  describe 'destroy' do
    let(:user) { FactoryBot.create(:user) }

    subject { delete api_v1_user_path(id: user.id) }

    before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the User model' do
      subject

      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end