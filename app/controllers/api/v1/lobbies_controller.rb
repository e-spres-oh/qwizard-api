# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :set_lobby, only: [:show, :update, :destroy]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_quiz, only: [:create, :index]

      def index
        @lobbies = @quiz.lobbies.all

        render :index
      end

      def create
        return head :unauthorized unless @quiz.user == current_user

        @lobby = Lobby.new(lobby_params.merge(code: SecureRandom.alphanumeric(6), quiz: @quiz))

        if @lobby.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def show
        render :show
      end

      def update
        if @lobby.update(lobby_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @lobby.destroy

        render :show
      end

      private

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end

      def set_lobby
        @lobby = Lobby.find(params[:id])
      end

      def require_authorisation
        head :unauthorized if @lobby.quiz.user != current_user
      end
      
      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end
    end
  end
end
