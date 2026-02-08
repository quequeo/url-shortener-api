module Api
  module V1
    class VisitsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link

      def index
        visits = paginate(@link.visits.recent)
        render json: VisitSerializer.render(visits)
      end

      private

      def set_link
        @link = current_user.links.find(params[:link_id])
      end
    end
  end
end
