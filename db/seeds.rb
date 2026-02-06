User.destroy_all
Link.destroy_all
Visit.destroy_all

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
  { url: 'https://google.com', user: user1 },
  { url: 'https://linkedin.com/in/johndoe', user: user1 },
  { url: 'https://infobae.com', user: user1 },
  { url: 'https://tycsports.com', user: user2 },
  { url: 'https://rails.org', user: user2 },
  { url: 'https://youtube.com/watch?v=dQw4w9WgXcQ', user: user2 }
]

links.each do |link_data|
  service = LinkShortenerService.new(link_data[:user])
  link = service.shorten(link_data[:url])

  rand(5..15).times do
    Visit.create!(
      link: link,
      ip_address: Faker::Internet.ip_v4_address,
      user_agent: Faker::Internet.user_agent
    )
    link.increment!(:click_count) # rubocop:disable Rails/SkipsModelValidations
  end
end

Rails.logger.info "Seeded #{User.count} users, #{Link.count} links, #{Visit.count} visits"
