# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def me
        return head 401 if session[:user_id].blank?

        @user = User.find(session[:user_id])

        render :show
      end

      def login
        @user = User.find_by(session_params)

        return head :unauthorized if @user.nil?

        session[:user_id] = @user.id
        render :show
      end

      def logout
        reset_session

        head :ok
      end

      private

      def session_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
