require 'rails_helper'

feature 'User can delete files from answer', %q{
  In order to delete wrong files from answer
  As an author
  I'd like to be able to delete files from answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, author: user) }
  given!(:answer) { create(:answer, :with_file, question: question, author: user) }

  describe 'Authinticated user' do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'can delete attached files from his own answer' do
      within '.answer-files' do
        click_on 'Delete'

        expect(page).not_to have_content question.files.first.filename.to_s
      end
    end

    scenario "can't delete attached files from another user's answer" do
      click_on 'Log Out'
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within '.answer-files' do
        expect(page).not_to have_content 'Delete'
      end
    end
  end

  scenario "Unauthinticated user can't delete attached files from answer" do
    visit question_path(question)

    within '.answer-files' do
      expect(page).not_to have_content 'Delete'
    end
  end

end
