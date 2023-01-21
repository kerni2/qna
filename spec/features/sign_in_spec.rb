require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticates user
  I'd like to be able to sign in
} do

  background { visit new_user_session_path }

  describe 'Registered' do
    scenario 'confirmed user tries to sign in' do
      user = create(:user, :confirmed)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'unconfirmed user tries to sign in' do
      user = create(:user)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
