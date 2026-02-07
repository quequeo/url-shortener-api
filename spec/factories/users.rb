FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@challenge.com" }
    password { 'pwd123' }
  end
end
