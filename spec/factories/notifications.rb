# spec/factories/notifications.rb
FactoryBot.define do
  factory :notification do
    association :user
    association :course

    message { "This is a test notification" }
    notification_type { "reminder" }
    read_at { nil }

    trait :read do
      read_at { Time.current }
    end

    trait :unread do
      read_at { nil }
    end
  end
end
