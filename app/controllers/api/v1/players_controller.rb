# frozen_string_literal: true

module Api
  module V1
    class PlayersController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :require_authorisation, only: [:update, :destroy]
      before_action :set_lobby, only: [:index, :create]
      
      def index
        @players = @lobby.players.all
        render :index
      end

      def create
        return head :unauthorized unless @lobby.quiz.user == current_user
        
        @player = Player.new(player_params.merge(lobby: @lobby))

        if @player.save
          render :show, status: :created
        else
          render 'api/v1/model_errors', locals: { errors: @player.errors }, status: :unprocessable_entity
        end
      end

      def show
        @player = Player.find(params[:id])
        render :show
      end

      def update
        @player = Player.find(params[:id])

        if @player.update(player_params)
          render :show
        else
          render 'api/v1/model_errors', locals: { errors: @player.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @player = Player.find(params[:id])
        @player.destroy

        render :show
      end

      private
      
      def require_authorisation
        player = Player.find(params[:id])

        head :unauthorized if player.lobby.quiz.user != current_user
      end

      def set_lobby
        @lobby = Lobby.find(params[:lobby_id])
      end

      def player_params
        params.require(:player).permit(:name, :hat)
      end
    end
  end
end