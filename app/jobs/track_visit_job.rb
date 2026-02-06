class TrackVisitJob < ApplicationJob
  queue_as :default

  def perform(link_id, ip_address, user_agent)
    Visit.create!(
      link_id: link_id,
      ip_address: ip_address,
      user_agent: user_agent
    )
  end
end
