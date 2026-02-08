module Api
  module V1
    class TopController < ApplicationController
      def index
        render json: LinkSerializer.render(Link.most_clicked)
      end
    end
  end
end
