require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  scenario "Unauthinticated user can't edit answer" do
    question = create(:question)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Edit'
    end
  end

  describe 'Authinticated user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user_id: user.id) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'edit his answer', js: true do
      within '.answers' do
        click_on('Edit')
        fill_in 'Body', with: 'edited answer'
        click_on('Save')

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        # expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors', js:true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      click_on 'Log Out'
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content 'Edit'
      end
    end

    scenario 'edit his answer with attached files', js: true do
      within '.answers' do
        click_on('Edit')
        fill_in 'Body', with: 'edited answer'

        attach_file 'Files', ["#{Rails.root}/spec/models/answer_spec.rb", "#{Rails.root}/spec/models/question_spec.rb"]

        click_on('Save')

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_link 'answer_spec.rb'
        expect(page).to have_link 'question_spec.rb'
      end
    end
  end
end
