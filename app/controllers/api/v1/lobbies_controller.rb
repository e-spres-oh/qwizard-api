# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:from_code, :join]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start]
      before_action :set_quiz, only: [:index, :create]

      def join
        lobby = Lobby.find(params[:id])

        @player = lobby.players.create(player_params)

        Pusher.trigger(lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        render :player, status: :created
      end

      def from_code
        @lobby = Lobby.find_by(code: params[:code])

        return head :not_found if @lobby.nil?

        render :show
      end

      def start
        @lobby = Lobby.find(params[:id])

        if @lobby.update(status: :in_progress)
          Pusher.trigger(@lobby.code, Lobby::LOBBY_START, {})
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
        end
      end

      def answer
        lobby = Lobby.find(params[:id])

        player = Player.find_by(id: params[:player_id])

        return head :not_found if player.nil?

        current_question = lobby.quiz.questions.find_by(order: lobby.current_question_index)
        @answers = current_question.answers

        current_question.answers.each do |answer|
          PlayerAnswer.where(player: player, answer_id: answer.id).delete_all
        end

        create_player_answer_model(player)

        send_answer_count_to_pusher(lobby)

        render :answer
      end

      def create_player_answer_model(player)

        answers_ids = params[:answers]
        answers_ids.each do |answer_id|
          answer = Answer.find(answer_id)
          PlayerAnswer.create(player: player, answer: answer)
        end

      end

      def send_answer_count_to_pusher(lobby)

        players_list = lobby.players.to_a
        players_list.each do |player|
          player.player_answers.any? do |player_answer|
            player_answer.answer.in?(@answers)
          end
        end

        Pusher.trigger(lobby.code, Lobby::ANSWER_SENT, { answer_count: players_list.count })

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

      def require_authorisation
        lobby = Lobby.find(params[:id])

        head :unauthorized if lobby.quiz.user != current_user
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
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
