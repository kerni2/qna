require 'rails_helper'

feature 'User can add comment to answer', %q{
  In order to provide additional info to answer
  As an authinticated user
  I'd like to be able to add comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question_id: question.id) }

  describe 'Authinticated user', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds comment to answer' do
      within ".new-answer-#{answer.id}-comment" do
        fill_in 'Body', with: 'some answer comment'
        click_on 'Add Comment'
      end

      expect(page).to have_content 'some answer comment'
    end

    scenario 'adds comment with error' do
      within ".new-answer-#{answer.id}-comment" do
        fill_in 'Body', with: ''
        click_on 'Add Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthinticated user tries to add comment' do
    visit question_path(question)

    within ".new-answer-#{answer.id}-comment" do
      expect(page).not_to have_content 'Add Comment'
    end
  end
end
