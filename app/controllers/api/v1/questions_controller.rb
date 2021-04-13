# frozen_string_literal: true

module Api
    module V1
        class QuestionsController < ApplicationController
          def index
            @questions = Question.all
            render :index
          end 

          def create
            @question = Question.new(question_params)
    
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
    
          def question_params
            params.require(:question).permit(:title, :answer_type, :order, :points, :time_limit, :quiz_id)
          end
        end
    end
end
  