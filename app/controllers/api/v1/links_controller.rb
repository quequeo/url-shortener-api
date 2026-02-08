module Api
  module V1
    class LinksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link, only: %i[show update destroy]

      def index
        links = current_user.links
                            .recent
                            .page(params[:page])
                            .per(page_size(Link.default_per_page))

        paginate_headers(links)
        render json: LinkSerializer.render(links)
      end

      def show
        render json: LinkAnalytics.new(@link).summary
      end

      def create
        link = current_user.links.create!(original_url: url_param)
        render json: LinkSerializer.render(link), status: :created
      end

      def update
        @link.update!(original_url: url_param)
        render json: LinkSerializer.render(@link)
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
        params.require(:original_url)
      end
    end
  end
end
