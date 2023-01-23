require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthinticated user
  I'd like to be able to sign in
} do

  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario 'user tries to sign in with github and request contain an email' do
      user = create(:user, :confirmed, email: 'somemail@mail.com')
      mock_auth_hash_github
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    describe 'Request does not contain an email' do
      background do
        mock_auth_hash_without_email_github
        click_on 'Sign in with GitHub'
      end

      scenario 'user tries to sign in with github' do
        expect(page).to have_content 'You need to register once. Than you can enter with Github.'
      end

      scenario 'user has registered and confirmed the email' do
        fill_in 'Email', with: 'somemail@mail.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
        click_on 'Sign up'

        open_email('somemail@mail.com')
        current_email.click_link 'Confirm my account'

        visit new_user_session_path
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'user has registered and did not confirmed the email' do
        fill_in 'Email', with: 'somemail@mail.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
        click_on 'Sign up'

        visit new_user_session_path
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Please confirm your registered email to access your account.'
      end
    end
  end

  describe 'Sign in with Facebook' do
    scenario 'user tries to sign in with facebook and request has email' do
      user = create(:user, :confirmed, email: 'somemail@mail.com')
      mock_auth_hash_facebook
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    describe 'Request does not contain an email' do
      background do
        mock_auth_hash_without_email_facebook
        click_on 'Sign in with Facebook'
      end

      scenario 'user tries to sign in with facebook' do
        expect(page).to have_content 'You need to register once. Than you can enter with Facebook.'
      end

      scenario 'user has registered and confirmed the email' do
        fill_in 'Email', with: 'somemail@mail.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
        click_on 'Sign up'

        open_email('somemail@mail.com')
        current_email.click_link 'Confirm my account'

        visit new_user_session_path
        click_on 'Sign in with Facebook'
        expect(page).to have_content 'Successfully authenticated from Facebook account.'
      end

      scenario 'user has registered and did not confirmed the email' do
        fill_in 'Email', with: 'somemail@mail.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
        click_on 'Sign up'

        visit new_user_session_path
        click_on 'Sign in with Facebook'
        expect(page).to have_content 'Please confirm your registered email to access your account.'
      end
    end
  end
end
