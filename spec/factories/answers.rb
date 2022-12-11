FactoryBot.define do
  factory :answer do
    body
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

  end
end
