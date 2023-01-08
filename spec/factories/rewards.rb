FactoryBot.define do
  factory :reward do
    title { 'Some Reward' }
    image { fixture_file_upload(Rails.root.join('spec', 'support', 'assets',
                                                'test.jpg'), 'image/png') }
  end
end
