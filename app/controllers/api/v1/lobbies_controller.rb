# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :require_authentication, except: [:from_code, :join, :answer]
      before_action :set_lobby, only: [:answer, :start, :destroy, :update, :show, :join, :score]
      before_action :set_quiz, only: [:index, :create]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start, :index, :create]

      def score
        @result = @lobby.players.to_a.map { |p| { name: p.name, hat: p.hat, points: get_points(p) } }

        render :score
      end

      def players_done
        question = Question.find_by(id: params[:question_id])

        return head :not_found if question.nil?

        @players = PlayerAnswer.where(answer: question.answers).map(&:player).uniq

        render :players
      end

      def answer
        player = Player.find_by(id: params[:player_id])

        return head :not_found if player.blank?

        @answers = @lobby.quiz.questions.find_by(order: @lobby.current_question_index).answers

        create_player_answers!(player)
        notify_answer_count

        render :answer
      end

      def start
        @lobby.update!(status: :in_progress)
        Pusher.trigger(@lobby.code, Lobby::LOBBY_START, {})

        NotifyQuestionStartJob.perform_now(lobby_id: @lobby.id, question_index: 1)

        show
      end

      def join
        @player = @lobby.players.create(player_params)

        Pusher.trigger(@lobby.code, Lobby::PLAYER_JOIN, { id: @player.id })
        created(:player)
      end

      def from_code
        @lobby = Lobby.find_by(code: params[:code])

        @lobby.nil? ? head(:not_found) : show
      end

      def index
        @lobbies = @quiz.lobbies.all
        render :index
      end

      def create
        @lobby = Lobby.new(lobby_params.merge(code: SecureRandom.alphanumeric(6), quiz: @quiz))

        @lobby.save ? created(:show) : error
      end

      def show
        render :show
      end

      def update
        @lobby.update(lobby_params) ? show : error
      end

      def destroy
        @lobby.destroy && show
      end

      private

      def created(template)
        render template, status: :created
      end

      def error
        render 'api/v1/model_errors', locals: { errors: @lobby.errors }, status: :unprocessable_entity
      end

      def get_points(player)
        @lobby.quiz.questions.to_a.map do |question|
          is_correct = question.answers.to_a.select(&:is_correct)
          PlayerAnswer.where(player: player, answer: is_correct).count == is_correct.count ? question.points : 0
        end.sum
      end

      def require_authorisation
        @quiz = @lobby.quiz if @quiz.nil?
        head :unauthorized if @quiz.user != current_user
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end

      def set_lobby
        @lobby = Lobby.find(params[:id])
      end

      def create_player_answers!(player)
        PlayerAnswer.where(player: player, answer_id: @answers.map(&:id)).destroy_all

        params[:answers].each { |id| PlayerAnswer.create(player: player, answer: Answer.find(id)) }
      end

      def notify_answer_count
        players = @lobby.players.to_a.select do |p|
          p.player_answers.any? { |pa| pa.answer.question.order == @lobby.current_question_index }
        end
        Pusher.trigger(@lobby.code, Lobby::ANSWER_SENT, { answer_count: players.count })
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
