# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      def index
        render json: Quiz.all
      end

      def create
        quiz = Quiz.new(quiz_params)

        if quiz.save
          render json: quiz, status: :created
        else
          render json: quiz.errors.full_messages, status: :unprocessable_entity
        end
      end

      def show
        render json: Quiz.find(params[:id])
      end

      def update
        quiz = Quiz.find(params[:id])

        if quiz.update(quiz_params)
          render json: quiz
        else
          render json: quiz.errors.full_messages, status: :unprocessable_entity
        end
      end

      def destroy
        quiz = Quiz.find(params[:id])
        quiz.destroy

        render json: quiz
      end

      private

      def quiz_params
        params.require(:quiz).permit(:title)
      end
    end
  end
end
