FactoryBot.define do
  factory :task do
    title { "MyString" }
    started_at { "2025-11-09 07:55:35" }
    finished_at { "2025-11-09 07:55:35" }
    is_completed { false }
  end
end
