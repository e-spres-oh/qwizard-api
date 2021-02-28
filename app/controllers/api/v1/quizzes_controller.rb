# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < AuthenticatedController
      before_action :require_authentication, except: [:show]
      before_action :require_authorisation, only: [:update, :destroy, :upload_image]

      def suggest_question
        conn = Faraday.new('https://fv4gjddr9a.execute-api.us-east-2.amazonaws.com')
        response = conn.get('Prod')
        data = JSON.parse(response.body)

        @question = Question.new(title: data['question'])
        @answers = data['answers'].map { |answer| Answer.new(title: answer['body'], is_correct: answer['correct']) }

        render :suggest
      end

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

      def upload_image
        @quiz = Quiz.find(params[:id])

        if @quiz.image.attach(params.require(:image))
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @quiz.errors }, status: :unprocessable_entity
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
          render 'api/v1/model_errors', locals: { errors: @quiz.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz = Quiz.find(params[:id])
        @quiz.destroy

        render :show
      end

      private

      def require_authorisation
        quiz = Quiz.find(params[:id])
        head :unauthorized if quiz.user != current_user
      end

      def quiz_params
        params.require(:quiz).permit(:title)
      end
    end
  end
end
