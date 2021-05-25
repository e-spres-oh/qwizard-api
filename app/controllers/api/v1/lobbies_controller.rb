# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:players_done, :from_code, :join, :answer, :score]
      before_action :set_lobby, except: [:from_code, :index, :create, :finished_lobbies]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start]
      before_action :set_quiz, only: [:index, :create]

      def players_done
        @players = @lobby.players.to_a.select do |p|
          p.player_answers.any? { |pa| pa.answer.question.id.to_s == params[:question_id] }
        end

        render :players_done
      end

      def score
        @scores = @lobby.players.map do |player|
          {
            name: player.name,
            hat: player.hat,
            points: CalculateScore.new.call(player)
          }
        end

        render :score
      end

      def answer
        player = Player.find_by(id: params[:player_id])

        return head :not_found if player.blank?

        question = @lobby.quiz.questions.find_by(order: @lobby.current_question_index)

        AddAnswers.new.call(@lobby, player, question, params[:answers])

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
        @player = @lobby.players.create(player_params.merge(user: current_user))

        Pusher.trigger(@lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        render :player, status: :created
      end

      def finished_lobbies
        @result = current_user.players.map(&:lobby)
        
        render :finished_lobbies
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
