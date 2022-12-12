require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete question
  As an author
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authinticated user' do

    scenario 'can delete his own question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question successfully deleted.'
      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end

    scenario "can't delete another user's question" do
      user = create(:user)
      sign_in(user)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content "You can't delete someone else's question."
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario "Unauthinticated user can't delete answers" do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
