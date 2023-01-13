require 'rails_helper'

feature 'User can add vote to question', %q{
  In order to rate the question
  As an authinticated user
  I'd like to be able to add vote to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authinticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds like vote to question' do
    within '.question-votes' do
        click_on 'like'

        expect(page).to have_content '1'
        expect(page).not_to have_content '0'
      end
    end

    scenario 'adds unlike vote to question' do
      within '.question-votes' do
        click_on 'unlike'

        expect(page).to have_content '-1'
        expect(page).not_to have_content '0'
      end
    end

    scenario "cancels his choice of vote" do
      within '.question-votes' do
        click_on 'like'
        click_on 'like'

        expect(page).to have_content '0'
        expect(page).not_to have_content '1'
      end
    end
  end

  scenario "Author can't vote for his question" do
    question = create(:question, user_id: user.id)

    sign_in(user)
    visit question_path(question)

    within '.question-votes' do
      expect(page).not_to have_content 'like'
      expect(page).not_to have_content 'unlike'
    end
  end

  scenario "Unauthinticated user can't vote for question" do
    visit question_path(question)

    within '.question-votes' do
      expect(page).not_to have_content 'like'
      expect(page).not_to have_content 'unlike'
    end
  end
end
