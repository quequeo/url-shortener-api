FactoryBot.define do
  factory :link do
    user
    sequence(:original_url) { |n| "https://example.com/page#{n}" }
    sequence(:short_code) { |n| "code#{n}" }
    click_count { 0 }
  end
end
