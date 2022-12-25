require 'rails_helper'

feature 'User can delete files from question', %q{
  In order to delete wrong files from question
  As an author
  I'd like to be able to delete files from question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, author: user) }

  describe 'Authinticated user' do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'can delete attached files from his own question' do
      within '.files' do
        click_on 'Delete'

        expect(page).not_to have_content question.files.first.filename.to_s
      end
    end

    scenario "can't delete attached files from another user's question" do
      click_on 'Log Out'
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within '.files' do
        expect(page).not_to have_content 'Delete'
      end
    end
  end

  scenario "Unauthinticated user can't delete attached files from question" do
    visit question_path(question)

    within '.files' do
      expect(page).not_to have_content 'Delete'
    end
  end

end
