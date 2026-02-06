user1 = User.create!(
  name: 'Demo User',
  email: 'demo@example.com',
  password: 'password123'
)

user2 = User.create!(
  name: 'Test User',
  email: 'test@example.com',
  password: 'password123'
)

links = [
  { url: 'https://github.com', user: user1 },
  { url: 'https://stackoverflow.com', user: user1 },
  { url: 'https://reddit.com/r/programming', user: user1 },
  { url: 'https://news.ycombinator.com', user: user1 },
  { url: 'https://ruby-doc.org', user: user2 },
  { url: 'https://rails.org', user: user2 },
  { url: 'https://api.rubyonrails.org', user: user2 }
]

links.each do |link_data|
  service = LinkShortenerService.new(link_data[:user])
  link = service.shorten(link_data[:url])

  rand(5..15).times do
    Visit.create!(
      link: link,
      ip_address: "192.168.1.#{rand(1..254)}",
      user_agent: ['Mozilla/5.0', 'Chrome/91.0', 'Safari/14.0'].sample
    )
    link.increment!(:click_count) # rubocop:disable Rails/SkipsModelValidations
  end
end

Rails.logger.info "Seeded #{User.count} users, #{Link.count} links, #{Visit.count} visits"
