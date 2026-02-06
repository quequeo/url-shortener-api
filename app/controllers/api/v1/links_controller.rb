module Api
  module V1
    class LinksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link, only: %i[show destroy]

      LINK_FIELDS = %i[id original_url short_code click_count created_at].freeze

      def index
        render json: current_user.links.order(created_at: :desc).as_json(only: LINK_FIELDS)
      end

      def show
        render json: @link.as_json(only: LINK_FIELDS)
      end

      def create
        link = LinkShortenerService.new(current_user).shorten(url_param)
        render json: link.as_json(only: LINK_FIELDS), status: :created
      end

      def destroy
        @link.destroy
        head :no_content
      end

      private

      def set_link
        @link = current_user.links.find(params[:id])
      end

      def url_param
        params.require(:url)
      end
    end
  end
end
