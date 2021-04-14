# frozen_string_literal: true

module Api
  module V1
    class PlayerAnswersController < ApplicationController
      def index
        @player_answers = PlayerAnswer.all
        render :index
      end

      def create
        @player_answer = PlayerAnswer.new(player_answer_params)

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

      def player_answer_params
        params.require(:player_answer).permit(:title, :is_correct, :question_id)
      end
    end
  end
end
