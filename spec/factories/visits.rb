FactoryBot.define do
  factory :visit do
    link
    ip_address { '192.168.1.1' }
    user_agent { 'Mozilla/5.0' }
  end
end
