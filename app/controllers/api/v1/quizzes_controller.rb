# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      def index
        @quizzes = Quiz.all
        render :index
      end

      def create
        @quiz = Quiz.new(quiz_params)

        if @quiz.save
          render :show, status: :created
        else
          render json: @quiz.errors.full_messages, status: :unprocessable_entity
        end
      end

      def show
        @quiz = Quiz.find(params[:id])
        render :show
      end

      def update
        @quiz = Quiz.find(params[:id])

        if @quiz.update(quiz_params)
          render :show
        else
          render json: @quiz.errors.full_messages, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz = Quiz.find(params[:id])
        @quiz.destroy

        render :show
      end

      private

      def quiz_params
        params.require(:quiz).permit(:title)
      end
    end
  end
end