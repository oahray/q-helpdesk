FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs }
    edited { false }
    user
    ticket
  end
end