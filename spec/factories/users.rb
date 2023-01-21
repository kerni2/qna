FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  trait :confirmed do
    confirmed_at { 'Wed, 07 Dec 2022 15:27:42 UTC +00:00' }
  end
end
