# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_quiz, only: [:index, :create]

      def index
        @questions = @quiz.questions.all
        render :index
      end

      def create
        return head :unauthorized unless @quiz.user == current_user

        @question = Question.new(question_params.merge(quiz: @quiz))

        if @question.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def show
        @question = Question.find(params[:id])
        render :show
      end

      def update
        @question = Question.find(params[:id])

        if @question.update(question_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @question = Question.find(params[:id])
        @question.destroy
        render :show
      end

      private

      def require_authorisation
        question = Question.find(params[:id])
        head :unauthorized if question.quiz.user != current_user
      end

      def set_quiz
        @quiz = Quiz.find(params[:quiz_id])
      end

      def question_params
        params.require(:question).permit(:title, :points, :time_limit, :answer_type, :order)
      end
    end
  end
end
