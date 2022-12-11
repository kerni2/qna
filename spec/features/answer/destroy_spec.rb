require 'rails_helper'

feature 'User can delete answer', %q{
  In order to delete answer
  As an author
  I'd like to be able to delete answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question_id: question.id, author: user) }

  describe 'Authinticated user' do

    scenario 'can delete his own answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete Answer'

      expect(page).to have_content 'Answer successfully deleted.'
      expect(page).not_to have_content answer.body
    end

    scenario "can't delete another user's answer" do
      user = create(:user)
      sign_in(user)
      visit question_path(question)
      click_on 'Delete Answer'

      expect(page).to have_content "You can't delete someone else's answer."
      expect(page).to have_content answer.body
    end
  end

  scenario "Unauthinticated user can't delete answers" do
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
