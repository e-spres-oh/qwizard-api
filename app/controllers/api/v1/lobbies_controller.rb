# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:from_code, :join]
      before_action :set_lobby, only: [:join, :start, :show, :update, :destroy]
      before_action :require_authorisation, only: [:show, :update, :destroy]
      before_action :set_quiz, only: [:index, :create]

      def join
        @player = @lobby.players.create(player_params)

        Pusher.trigger(@lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        render :player, status: :created
      end

      def start
        @lobby.status = :in_progress
        @lobby.save

        Pusher.trigger(@lobby.code, Lobby::LOBBY_START)
        render :show
      end

      def from_code
        @lobby = Lobby.find_by(code: params[:code])

        return head :not_found if @lobby.nil?

        render :show
      end

      def index
        return head :unauthorized unless @quiz.user == current_user

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

      def require_authorisation
        head :unauthorized if @lobby.quiz.user != current_user
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end

      def set_lobby
        @lobby = Lobby.find(params[:id])
      end

      def player_params
        params.require(:player).permit(:name, :hat)
      end

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end
    end
  end
end
