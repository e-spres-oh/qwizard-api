# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_quiz, only: [:index, :create]

      def index
        @lobbies = @quiz.lobbies.all
        render :index
      end

      def create
        @lobby = Lobby.new(lobby_params.merge(code: SecureRandom.alphanumeric(6), quiz: @quiz))

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

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end

      def require_authorisation
        @lobby = Lobby.find(params[:id])
        head :forbidden if @lobby.quiz.user != current_user
      end

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end
    end
  end
end
