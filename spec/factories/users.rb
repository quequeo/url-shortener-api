FactoryBot.define do
  factory :user do
    name { 'Url LaLaLa' }
    email { "user#{rand(1000..9999)}@challenge.com" }
    password { 'Pa$$w0rd!' }
  end
end
