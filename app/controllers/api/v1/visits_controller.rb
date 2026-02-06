module Api
  module V1
    class VisitsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_link

      def index
        visits = @link.visits.order(created_at: :desc).limit(100)
        render json: visits.as_json(only: %i[id ip_address user_agent created_at])
      end

      private

      def set_link
        @link = current_user.links.find(params[:link_id])
      end
    end
  end
end
