# frozen_string_literal: true

module Api
  module V1
    class AnswersController < ApplicationController
      def index
        @answers = Answer.all
        render :index
      end

      def create
        @answer = Answer.create(answer_params)
        if @answer.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def show
        @answer = Answer.find_by!(id: params[:id])
        render :show
      end

      def update
        @answer = Answer.find_by!(id: params[:id])
        if @answer.update(answer_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer = Answer.find_by!(id: params[:id])
        @answer.destroy!
        render :show
      end

      private

      def answer_params
        params.require(:answer).permit(:title, :is_correct, :question_id)
      end
    end
  end
end
