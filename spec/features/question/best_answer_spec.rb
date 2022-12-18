require 'rails_helper'

feature 'User can choose the best answer to the question', %q{
  In order to show other users right answer
  As an author
  I'd like to be able to choose best answer
} do

  describe 'Authinticated user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given!(:answers) { create_list(:answer, 3, question: question, author: user) }

    scenario 'can choose best answer for his question' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answers.first.id}" do
        click_on 'Mark as Best'

        expect(page).to have_content '[Best]'
        expect(page).not_to have_content 'Mark as Best'
      end
    end

    scenario "can't choose best answer for other user's question" do
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within ".answers" do
        expect(page).not_to have_content 'Mark as Best'
      end
    end

    scenario "can change best answer", js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answers.first.id}" do
        click_on 'Mark as Best'
      end

      within "#answer-#{answers.last.id}" do
        click_on 'Mark as Best'

        expect(page).to have_content '[Best]'
        expect(page).not_to have_content 'Mark as Best'
      end

      within "#answer-#{answers.first.id}" do
        expect(page).not_to have_content '[Best]'
        expect(page).to have_content 'Mark as Best'
      end
    end
  end

  scenario "Unauthinticated user can't choose best answer" do
    question = create(:question)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Mark as Best'
    end
  end

end
