# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < ApplicationController
      def index
        @lobbies = Lobby.all
        render :index
      end

      def create
        @lobby = Lobby.new(lobby_params)

        if @lobby.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def show
        @lobby = Lobby.find(params[:id])
        render :show
      end

      def update
        @lobby = Lobby.find(params[:id])

        if @lobby.update(lobby_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @lobby = Lobby.find(params[:id])
        @lobby.destroy

        render :show
      end

      private

      def lobby_params
        params.require(:lobby).permit(:code, :status, :current_question_index, :quiz_id)
      end
    end
  end
end
