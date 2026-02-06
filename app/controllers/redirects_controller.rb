class RedirectsController < ApplicationController
  def show
    link = Link.find_by!(short_code: params[:short_code])

    TrackVisitJob.perform_later(link.id, request.remote_ip, request.user_agent)
    link.increment!(:click_count) # rubocop:disable Rails/SkipsModelValidations

    redirect_to link.original_url, status: :found, allow_other_host: true
  end
end
