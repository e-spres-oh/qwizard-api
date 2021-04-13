#frozen_string_literal: true

module Api
  module V1
    class LobbiesController < ApplicationController
      def index
        @lobbies = Lobby.all
        render :index
      end

      def create
        @lobby = Lobby.create(lobby_params)
        if @lobby.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def show
        @lobby = Lobby.find_by!(id: params[:id])
        render :show
      end

      def update 
        @lobby = Lobby.find_by!(id: params[:id])
        if @lobby.update(lobby_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @lobby = Lobby.find_by!(id: params[:id])
        @lobby.destroy!
        render :show
      end

      private 
      def lobby_params
        params.require(:lobby).permit(:code, :current_question_index, :status, :quiz_id)
      end
      
    end
  end
end
  