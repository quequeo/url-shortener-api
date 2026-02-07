module Api
  module V1
    class VisitsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link

      def index
        visits = @link.visits.order(created_at: :desc).page(params[:page]).per(page_size)

        paginate_headers(visits)
        render json: visits.as_json(only: %i[id ip_address user_agent created_at])
      end

      private

      def set_link
        @link = current_user.links.find(params[:link_id])
      end

      def page_size
        value = params[:per_page].to_i
        return value if value.positive?

        Visit.default_per_page
      end
    end
  end
end
