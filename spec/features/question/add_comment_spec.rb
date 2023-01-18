require 'rails_helper'

feature 'User can add comment to question', %q{
  In order to provide additional info to question
  As an authinticated user
  I'd like to be able to add comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authinticated user', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds comment to question' do
      within ".new-question-comment" do
        fill_in 'Body', with: 'some comment'
        click_on 'Add Comment'
      end

      expect(page).to have_content 'some comment'
    end

    scenario 'adds comment with error' do
      within ".new-question-comment" do
        fill_in 'Body', with: ''
        click_on 'Add Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthinticated user tries to add comment' do
    visit question_path(question)

    within ".new-question-comment" do
      expect(page).not_to have_content 'Add Comment'
    end
  end
end
