require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community
  As an authenticated user
  I'd like to be able to write a answer
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authinticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    background { visit question_path(question) }

    scenario 'add answer' do
      fill_in 'answer[body]', with: 'Some Body'
      click_on 'Add Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Some Body'
    end

    scenario 'add answer with errors' do
      click_on 'Add Answer'

      expect(page).to have_content "Answer body can't be blank"
    end
  end

  scenario 'Unauthinticated user tries to ask a question' do
    visit question_path(question)
    click_on 'Add Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
