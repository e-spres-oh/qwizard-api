# frozen_string_literal: true

module Api
  module V1
    class AnswersController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_question, only: [:index, :create]

      def index
        @answers = @question.answers.all
        render :index
      end

      def create
        return head :unauthorized unless @question.quiz.user == current_user

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

      def require_authorisation
        answer = Answer.find(params[:id])
        head :unauthorized if answer.question.quiz.user != current_user
      end

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:title, :is_correct)
      end
    end
  end
end
