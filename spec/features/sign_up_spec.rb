require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and add answers
  As an unregistered user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    open_email('user@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Registered user tries to sign up' do
    user = create(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Unregistered user tries to sign up with invalid attributes' do
    fill_in 'Email', with: 'usertest.com'
    fill_in 'Password', with: '123'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end
end
