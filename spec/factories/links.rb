FactoryBot.define do
  factory :link do
    user
    original_url { 'https://google.com' }
    short_code { "2#{SecureRandom.alphanumeric(6)}" }
    click_count { 0 }
  end
end
