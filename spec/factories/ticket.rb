FactoryBot.define do
  factory :ticket do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs }
    processing { false }
    closed { false }
    closed_at { nil }
    association :customer, factory: :user
    association :closed_by, factory: :agent

    factory :pending_ticket do
      closed_by { nil }
    end

    factory :processing_ticket do
      processing { true }
    end

    factory :closed_ticket do
      closed { true }
      closed_at { 1.day.ago }
    end

    factory :three_months_ago_closed_ticket do
      created_at { 4.months.ago }
      closed { true }
      closed_at { 3.months.ago }
    end

    factory :ticket_with_comments do
      transient do
        comments_count { 3 }
      end

      after(:create) do |ticket, evaluator|
        create_list(:comment, evaluator.comments_count, ticket: ticket)
      end
    end
  end
end
