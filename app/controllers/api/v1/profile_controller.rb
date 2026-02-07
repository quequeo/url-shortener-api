module Api
  module V1
    class ProfileController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: {
          id: current_user.id,
          email: current_user.email,
          name: current_user.name,
          api_key: current_user.api_key
        }
      end
    end
  end
end
