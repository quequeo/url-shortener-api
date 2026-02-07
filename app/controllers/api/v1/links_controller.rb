module Api
  module V1
    class LinksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link, only: %i[show destroy]

      LINK_FIELDS = %i[id original_url short_code click_count created_at].freeze

      def index
        links = current_user.links.order(created_at: :desc).page(params[:page]).per(page_size)

        paginate_headers(links)

        render json: links.as_json(only: LINK_FIELDS)
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

      def page_size
        value = params[:per_page].to_i
        value = Link.per_page / 4 if value <= 0
        [value, Link.per_page].min
      end
    end
  end
end
