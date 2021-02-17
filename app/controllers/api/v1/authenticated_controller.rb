# frozen_string_literal: true

module Api
  module V1
    class AuthenticatedController < ApplicationController
      before_action :require_authentication

      private

      def require_authentication
        head :unauthorized unless logged_in?
      end

      def logged_in?
        session[:user_id].present?
      end

      def current_user
        User.find(session[:user_id])
      end
    end
  end
end
