# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < AuthenticatedController
      before_action :require_authentication, except: [:show]
      before_action :set_quiz, only: [:show, :update, :destroy]
      before_action :require_authorisation, only: [:update, :destroy]

      def index
        @quizzes = current_user.quizzes
        render :index
      end

      def create
        @quiz = Quiz.new(quiz_params.merge(user: current_user))

        if @quiz.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @quiz.errors }, status: :unprocessable_entity
        end
      end

      def show
        render :show
      end

      def update
        if @quiz.update(quiz_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @quiz.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz.destroy

        render :show
      end

      private

      def set_quiz
        @quiz = Quiz.find(params[:id])
      end

      def require_authorisation
        head :unauthorized if @quiz.user != current_user
      end

      def quiz_params
        params.require(:quiz).permit(:title)
      end
    end
  end
end
