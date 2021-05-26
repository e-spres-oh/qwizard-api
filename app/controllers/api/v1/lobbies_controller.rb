# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:players_done, :from_code, :join, :answer, :score]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start]
      before_action :set_quiz, only: [:index, :create]
      before_action :set_lobby, only: [:start, :join, :show, :destroy, :update, :answer]

      def finished
        @lobbies = Player.joins(:lobby).where(user_id: session[:user_id], 'lobby.status' => 'finished').map(&:lobby)
        render :finished
      end

      def players_done
        @players = PlayersDoneInLobby.new(params[:id]).call

        render :players_done
      end

      def score
        @scores = ComputeLobbyScores.new(params[:id]).call

        render :score
      end

      def answer
        player = Player.find_by(id: params[:player_id])

        return head :not_found if player.blank?

        question = @lobby.quiz.questions.find_by(order: @lobby.current_question_index)

        create_player_answers!(player, question)
        notify_answer_count(@lobby)

        @answers = question.answers
        render :answer
      end

      def start
        @lobby.update!(status: :in_progress)
        Pusher.trigger(@lobby.code, Lobby::LOBBY_START, {})

        NotifyQuestionStartJob.perform_now(lobby_id: @lobby.id, question_index: 1)

        render :show
      end

      def join
        @player = @lobby.players.create(player_params)

        Pusher.trigger(@lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        render :player, status: :created
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

      def set_lobby
        @lobby = Lobby.find(params[:id])

        head :not_found if @lobby.nil?
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end

      def create_player_answers!(player, question)
        PlayerAnswer.where(player: player, answer_id: question.answers.map(&:id)).destroy_all

        params[:answers].each do |id|
          answer = Answer.find(id)
          PlayerAnswer.create(player: player, answer: answer)
        end
      end

      def notify_answer_count(lobby)
        players = lobby.players.to_a.select do |p|
          p.player_answers.any? { |pa| pa.answer.question.order == lobby.current_question_index }
        end
        Pusher.trigger(lobby.code, Lobby::ANSWER_SENT, { answer_count: players.count })
      end

      def player_params
        params.require(:player).permit(:name, :hat).merge(user_id: session[:user_id])
      end

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end
    end
  end
end
