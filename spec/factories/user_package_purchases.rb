FactoryBot.define do
  factory :user_package_purchase do
    user { nil }
    package { nil }
    purchased_at { "2025-08-08 11:07:23" }
    expires_at { "2025-08-08 11:07:23" }
    status { 1 }
  end
end
