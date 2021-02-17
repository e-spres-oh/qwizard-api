# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
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
        @user = User.find(params[:id])
        render :show
      end

      def update
        @user = User.find(params[:id])

        if @user.update(user_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @user = User.find(params[:id])
        @user.destroy

        render :show
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :hat)
      end
    end
  end
end
