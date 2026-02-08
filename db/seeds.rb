User.destroy_all
Link.destroy_all
Visit.destroy_all

james = User.create!(name: 'James Garcia', email: 'james@example.com', password: 'pwd123')
john = User.create!(name: 'John Miller', email: 'john@example.com', password: 'pwd123')
victoria = User.create!(name: 'Victoria Ross', email: 'victoria@example.com', password: 'pwd123')
philippe = User.create!(name: 'Philippe Durand', email: 'philippe@example.com', password: 'pwd123')
sebastian = User.create!(name: 'Sebastian Torres', email: 'sebastian@example.com', password: 'pwd123')
jennifer = User.create!(name: 'Jennifer Walsh', email: 'jennifer@example.com', password: 'pwd123')

links = [
  { original_url: 'https://github.com/quequeo/url-shortener-api', user: james },
  { original_url: 'https://linkedin.com/in/jamesgarcia', user: james },
  { original_url: 'https://stackoverflow.com/questions/4022129/getting-the-id-of-element',
    user: james },
  { original_url: 'https://medium.com/@jamesgarcia/building-scalable-apis-with-rails', user: james },
  { original_url: 'https://www.youtube.com/watch?v=xAR6N9N8e6U&list=RDxAR6N9N8e6U&start_radio=1&t=1049s', user: james },

  { original_url: 'https://linkedin.com/in/johnmiller', user: john },
  { original_url: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms', user: john },
  { original_url: 'https://notion.so/johnmiller/Project-Roadmap-2026-abc123', user: john },
  { original_url: 'https://twitter.com/dhh/status/1234567890', user: john },

  { original_url: 'https://linkedin.com/in/victoriaross', user: victoria },
  { original_url: 'https://figma.com/file/abc123/landing-page-redesign', user: victoria },
  { original_url: 'https://dribbble.com/shots/12345678-Dashboard-UI', user: victoria },
  { original_url: 'https://www.awwwards.com/sites/stripe', user: victoria },

  { original_url: 'https://linkedin.com/in/philippedurand', user: philippe },
  { original_url: 'https://dev.to/philippedurand/redis-pub-sub-in-production-3k9f', user: philippe },
  { original_url: 'https://arxiv.org/abs/2301.07041', user: philippe },

  { original_url: 'https://linkedin.com/in/sebastiantorres', user: sebastian },
  { original_url: 'https://github.com/rails/rails/pull/50123', user: sebastian },
  { original_url: 'https://rubygems.org/gems/sidekiq', user: sebastian },
  { original_url: 'https://www.postgresql.org/docs/16/indexes.html', user: sebastian },
  { original_url: 'https://youtube.com/watch?v=dQw4w9WgXcQ', user: sebastian },

  { original_url: 'https://linkedin.com/in/jenniferwalsh', user: jennifer },
  { original_url: 'https://calendly.com/jenniferwalsh/30min', user: jennifer },
  { original_url: 'https://docs.stripe.com/api/charges/create', user: jennifer },
  { original_url: 'https://slack.com/intl/en/solutions/engineering', user: jennifer }
]

links.each do |link_data|
  link = link_data[:user].links.create!(original_url: link_data[:original_url])

  rand(3..25).times do
    Visit.create!(
      link: link,
      ip_address: Faker::Internet.ip_v4_address,
      user_agent: Faker::Internet.user_agent
    )
    link.increment!(:click_count) # rubocop:disable Rails/SkipsModelValidations
  end
end

Rails.logger.info "Seeded #{User.count} users, #{Link.count} links, #{Visit.count} visits"
