require 'rails_helper'

feature 'Authenticated user can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  scenario "Unauthinticated user can't edit question" do
    question = create(:question)
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_content 'Edit'
    end
  end

  describe 'Authinticated user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user_id: user.id) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'edit his question', js: true do
      within '.question .actions' do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new question text'
        click_on 'Update'

        # expect(page).not_to have_selector 'textarea'
      end

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
      expect(page).to have_content 'new title'
      expect(page).to have_content 'new question text'
    end

    scenario 'edit his question with errors', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Update'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'edit his question with attached files', js: true do
      within '.question .actions' do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new question text'

        attach_file 'Files', ["#{Rails.root}/spec/models/answer_spec.rb", "#{Rails.root}/spec/models/question_spec.rb"]

        click_on 'Update'

      end

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
      expect(page).to have_content 'new title'
      expect(page).to have_content 'new question text'
      expect(page).to have_link 'answer_spec.rb'
      expect(page).to have_link 'question_spec.rb'
    end

    scenario "tries to edit other user's question" do
      click_on 'Log Out'
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_content 'Edit'
      end
    end
  end
end
