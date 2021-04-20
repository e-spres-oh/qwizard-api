# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'index' do
    subject { get api_v1_users_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current users' do
      foo_user = FactoryBot.create(:user)
      bar_user = FactoryBot.create(:user)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_user, bar_user].as_json.map {|el| el.except("password")})
    end
  end

  describe 'create' do
    let(:user_params) do
      { username: 'name.surename', email:'name@example.com', password: 'qwerty' }
    end

    subject { post api_v1_users_path, params: { user: user_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a User model with the request params' do
      subject

      expect(User.last.username).to eq(user_params[:username])
    end

    it 'responds with the created User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(User.last.as_json.except("password"))
    end

    context 'invalid parameters' do
      let(:user_params) do
        { no_email: 'test' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
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
    expect(parsed_response).to eq(user.as_json.except("password"))
    end
  end

  describe 'update' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) do
      { username: 'name.surename', email: 'name@example.com', password: 'qwerty' }
    end
    subject { put api_v1_user_path(id: user.id), params: { user: user_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the User attributes' do
      subject

      expect(user.reload.username).to eq('name.surename')
    end

    it 'responds with the updated User model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(user.reload.as_json.except("password"))
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

    it 'responds with the destroyed Quiz model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(user.as_json.except("password"))
    end
  end
end