# frozen_string_literal: true

module Api
  module V1
    class UsersController < AuthenticatedController
      before_action :require_authentication, except: [:recover_password, :recovery_token, :create]
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :require_authorisation, only: [:update, :destroy]

      def recover_password
        user = User.find_by(recovery_token: params.require(:recovery_token))

        return head :not_found if user.nil?

        user.update!(recovery_token: nil, password: SecureRandom.alphanumeric(16))

        PasswordRecoveryMailer.with(user: user).recover_password.deliver_later
        head :ok
      end

      def recovery_token
        user = User.find_by(email: params[:email])

        return head :not_found if user.nil?

        user.update!(recovery_token: SecureRandom.alphanumeric(16))

        PasswordRecoveryMailer.with(user: user).recovery_token.deliver_later
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
