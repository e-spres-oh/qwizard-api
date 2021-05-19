# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:from_code, :join]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start]
      before_action :set_quiz, only: [:index, :create]
      before_action :set_lobby, only: [:join, :start, :answer, :show, :update, :destroy]
      before_action :set_player, only: [:answer]
      before_action :set_current_question, only: [:answer]

      def join
        @player = @lobby.players.create(player_params)

        Pusher.trigger(@lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        render :player, status: :created
      end

      def start
        @lobby.status = :in_progress

        if @lobby.save
          Pusher.trigger(@lobby.code, Lobby::LOBBY_START, {})
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def answer
        return head :unauthorized unless @lobby.players.include? @player

        replace_player_answers

        Pusher.trigger(@lobby.code, Lobby::ANSWER_SENT,
                       { answer_count: @question.player_answers.distinct.count('player_id') })

        render @question.answers
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
        lobby = Lobby.find(params[:id])

        head :unauthorized if lobby.quiz.user != current_user
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])

        return head :not_found if @quiz.nil?
      end

      def set_player
        @player = Player.find(params[:player_id])

        return head :not_found if @player.nil?
      end

      def set_lobby
        @lobby = Lobby.find(params[:id])

        return head :not_found if @lobby.nil?
      end

      def set_current_question
        @question = @lobby.quiz.questions.detect { |question| question.order == @lobby.current_question_index }

        return head :not_found if @question.nil?
      end

      def replace_player_answers
        @question.player_answers.where(player: @player).destroy_all

        params[:answers].each do |answer|
          PlayerAnswer.create(answer_id: answer, player: @player)
        end
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
