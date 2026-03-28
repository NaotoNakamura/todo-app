FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    provider_name { "google" }
    sequence(:provider_uid) { |n| "google_uid_#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
