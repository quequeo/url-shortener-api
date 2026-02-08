class TrackVisitJob < ApplicationJob
  queue_as :default
  discard_on ActiveRecord::RecordNotFound

  def perform(link_id, ip_address, user_agent)
    Visit.create!(
      link_id: link_id,
      ip_address: ip_address,
      user_agent: user_agent
    )
  end
end
