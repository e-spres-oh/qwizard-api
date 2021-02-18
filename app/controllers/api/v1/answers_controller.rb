# frozen_string_literal: true

module Api
  module V1
    class AnswersController < ApplicationController
      before_action :set_question, only: [:index, :create]

      def index
        @answers = @question.answers.all
        render :index
      end

      def create
        @answer = Answer.new(answer_params.merge(question: @question))

        if @answer.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def show
        @answer = Answer.find(params[:id])
        render :show
      end

      def update
        @answer = Answer.find(params[:id])

        if @answer.update(answer_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer = Answer.find(params[:id])
        @answer.destroy

        render :show
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:title, :is_correct)
      end
    end
  end
end
