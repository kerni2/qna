FactoryBot.define do
  factory :subscription do
    association :question
    association :user
  end

  trait :invalid do
    question { nil }
  end
end
