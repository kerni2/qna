require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community
  As an authenticated user
  I'd like to be able to write a answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authinticated user', js:true do
    background { sign_in(user) }

    background { visit question_path(question) }

    scenario 'add answer' do
      within '.new-answer' do
        fill_in 'answer[body]', with: 'Some Body'
        click_on 'Add Answer'
      end

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Some Body'
      end
    end

    scenario 'add answer with errors' do
      click_on 'Add Answer'

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'add answer with attached files' do
      within '.new-answer' do
        fill_in 'answer[body]', with: 'Some Body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Add Answer'
      end

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthinticated user tries to create answer' do
    visit question_path(question)
    click_on 'Add Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'answer[body]', with: 'Some Answer Body'
          click_on 'Add Answer'
        end

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Some Answer Body'
        end
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Some Answer Body'
      end
    end
  end
end
