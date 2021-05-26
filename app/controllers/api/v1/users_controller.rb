# frozen_string_literal: true

require 'securerandom'
module Api
  module V1
    class UsersController < AuthenticatedController
      before_action :require_authentication, except: [:recover_password, :recovery_token, :create]
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :check_token, only: [:recover_password]

      def recover_password
        @user.password = SecureRandom.base64(10)
        @user.token = nil

        if @user.save
          PasswordRecoveryMailer.with(user: @user).recover_password.deliver_later
          head :ok
        else
          render 'api/v1/model_errors', locals: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def recovery_token
        return head :bad_request unless params.key?(:email)

        user = User.find_by(email: params[:email])

        return head :not_found if user.nil?

        token = SecureRandom.hex(16)
        user.update!(token: token)

        head :ok
      end

      def index
        @users = User.all
        render :index
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def show
        render :show
      end

      def update
        if @user.update(user_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy

        render :show
      end

      private

      def check_token
        return head :bad_request unless params.key?(:token)

        @user = User.find_by(token: params[:token])
        return head :not_found if @user.nil?
      end

      def user_params
        params.require(:user).permit(:username, :email, :password, :hat)
      end

      def set_user
        @user = User.find(params[:id])
      end

      def require_authorisation
        head :unauthorized if @user != current_user
      end
    end
  end
end
