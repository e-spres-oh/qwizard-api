# frozen_string_literal: true

module Api
  module V1
    class PlayersController < AuthenticatedController
      before_action :require_authentication, except: [:index, :show]
      before_action :set_lobby, only: [:index, :create]

      def index
        @players = @lobby.players.all
        render :index
      end

      def create
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

      def set_lobby
        @lobby = Lobby.find(params[:lobby_id])
      end

      def player_params
        params.require(:player).permit(:name, :hat)
      end
    end
  end
end
