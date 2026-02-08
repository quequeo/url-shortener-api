module Api
  module V1
    class VisitsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link

      def index
        visits = @link.visits
                      .recent
                      .page(params[:page])
                      .per(page_size(Visit.default_per_page))

        paginate_headers(visits)
        render json: VisitSerializer.render(visits)
      end

      private

      def set_link
        @link = current_user.links.find(params[:link_id])
      end
    end
  end
end
