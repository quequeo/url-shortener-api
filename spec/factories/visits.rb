FactoryBot.define do
  factory :visit do
    link
    sequence(:ip_address) { |n| "192.168.1.#{(n % 254) + 1}" }
    user_agent { 'Mozilla/5.0' }
  end
end
