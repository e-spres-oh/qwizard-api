# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController # rubocop:disable Metrics/ClassLength
      before_action :require_authentication, except: [:players_done, :from_code, :join, :answer, :score]
      before_action :require_authorisation, only: [:show, :update, :destroy, :start]
      before_action :set_quiz, only: [:index, :create]

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def players_done
        lobby = Lobby.find(params[:id])
        question = Question.find_by(id: params[:question_id])

        return head :not_found if question.blank?

        @players = []
        lobby.players.each do |player|
          question.answers.each do |answer|
            @players.push(player) if PlayerAnswer.find_by(player: player, answer: answer)
          end
        end

        @players.uniq!
        render :players
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def score
        lobby = Lobby.find(params[:id])

        @results = lobby.players.map do |player|
          {
            name: player.name,
            hat: player.hat,
            points: get_points(lobby, player)
          }
        end

        render :score
      end

      def answer
        player = Player.find_by(id: params[:player_id])

        return head :not_found if player.blank?

        lobby = Lobby.find(params[:id])
        question = lobby.quiz.questions.find_by(order: lobby.current_question_index)

        create_player_answers!(player, question)
        notify_answer_count(lobby)

        @answers = question.answers
        render :answer
      end

      def start
        @lobby = Lobby.find(params[:id])
        @lobby.update!(status: :in_progress)
        Pusher.trigger(@lobby.code, Lobby::LOBBY_START, {})

        NotifyQuestionStartJob.perform_now(lobby_id: @lobby.id, question_index: 1)

        render :show
      end

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

      def get_points(lobby, player)
        questions = lobby.quiz.questions

        questions.each do |question|
          next unless received_points?(question, player)

          question.points
        end.sum
      end

      def received_points?(question, player)
        correct_answers = question.answers.select(&:is_correct)
        # rubocop:disable Metrics/LineLength
        question unless (PlayerAnswer.where(player: player, answer: correct_answers).count == correct_answers.count) && (PlayerAnswer.where(player: player).count == correct_answers.count)
        # rubocop:enable Metrics/LineLength
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
        params.require(:player).permit(:name, :hat)
      end

      def lobby_params
        params.require(:lobby).permit(:status, :current_question_index)
      end
    end
  end
end
