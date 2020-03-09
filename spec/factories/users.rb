FactoryBot.define do
  factory :user, aliases: [:customer] do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "foobar" }
    admin { false }
    support_agent { false }

    factory :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
      admin { true }
    end

    factory :agent do
      sequence(:email) { |n| "agent#{n}@example.com" }
      support_agent { true }
    end

    # user_with_tickets will create ticket data after the user has been created
    factory :customer_with_tickets do
      transient do
        tickets_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:ticket, evaluator.tickets_count, customer: user)
      end
    end
  end
end
