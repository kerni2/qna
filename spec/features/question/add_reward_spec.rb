require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to give reward for best answer
  As an author
  I'd like to be able to add reward
} do

  given(:user) { create(:user) }

  scenario 'User adds reward when ask question', js:true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'some title'
    fill_in 'Body', with: 'some text'

    within '.reward' do
      attach_file 'Image', "#{Rails.root}/spec/support/assets/test.jpg"
      fill_in 'Title award', with: 'Reward name'
    end

    click_on 'Ask'

    expect(page).to have_content 'Reward name'

  end
end
