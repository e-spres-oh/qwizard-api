# frozen_string_literal: true

module Api
  module V1
    class PlayerAnswersController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_player, only: [:index, :create]

      def index
        @player_answers = @player.player_answers.all
        render :index
      end

      def create
        return head :unauthorized unless @player.lobby.quiz.user == current_user

        @player_answer = PlayerAnswer.new(player_answer_params.merge(player: @player))

        if @player_answer.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @player_answer.errors }, status: :unprocessable_entity
        end
      end

      def show
        @player_answer = PlayerAnswer.find(params[:id])
        render :show
      end

      def update
        @player_answer = PlayerAnswer.find(params[:id])

        if @player_answer.update(player_answer_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @player_answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @player_answer = PlayerAnswer.find(params[:id])
        @player_answer.destroy
        render :show
      end

      private

      def require_authorisation
        player_answer = PlayerAnswer.find(params[:id])
        head :unauthorized if player_answer.player.lobby.quiz.user != current_user
      end

      def set_player
        @player = Player.find(params[:player_id])
      end

      def player_answer_params
        params.require(:player_answer).permit(:answer_id)
      end
    end
  end
end
