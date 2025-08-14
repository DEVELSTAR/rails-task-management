# spec/factories/notifications.rb
FactoryBot.define do
  factory :notification do
    association :user
    association :course
    notification_type { Notification.notification_types.keys.sample }
    read { false }
    read_at { nil }

    trait :read do
      read { true }
      read_at { Time.current }
    end

    trait :unread do
      read { false }
      read_at { nil }
    end
  end
end
