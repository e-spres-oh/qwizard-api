# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:from_code, :join, :answer]
      before_action :set_lobby, only: [:join, :start, :answer, :show, :update, :destroy]
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

      def answer
        @player = Player.find_by(id: params[:player_id])

        return head :not_found if @player.nil?

        @answers = Question.find_by!(quiz_id: @lobby.quiz.id, order: @lobby.current_question_index).answers
        PlayerAnswer.where(answer: @answers, player: @player).delete_all

        return head :not_found unless create_new_answers

        trigger_answer_sent

        render :answer
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

      def trigger_answer_sent
        players = @lobby.players.to_a.select do |player|
          player.player_answers.any? do |player_answer|
            player_answer.answer.in?(@answers)
          end
        end

        Pusher.trigger(@lobby.code, Lobby::ANSWER_SENT, { answer_count: players.count })
      end

      def create_new_answers
        answer_params.each do |val|
          answer = Answer.find_by(id: val)

          return false if answer.nil?

          PlayerAnswer.create(player: @player, answer: answer)
        end
      end

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

      def answer_params
        params.require(:answers)
      end

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end
    end
  end
end
