FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "http://link.com" }
  end

  trait :for_question do
    association :linkable, factory: :question
  end
end
