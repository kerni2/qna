require 'rails_helper'

feature 'User can add vote to answer', %q{
  In order to rate the answer
  As an authinticated user
  I'd like to be able to add vote to answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question_id: question.id) }

  describe 'Authinticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds like vote to answer' do
    within "#answer-#{answer.id}" do
        click_on 'like'

        within '.answer-votes' do
          expect(page).to have_content '1'
          expect(page).not_to have_content '0'
        end
      end
    end

    scenario 'adds unlike vote to answer' do
      within "#answer-#{answer.id}" do
        click_on 'unlike'

        within '.answer-votes' do
          expect(page).to have_content '-1'
          expect(page).not_to have_content '0'
        end
      end
    end

    scenario "cancels his choice of vote" do
      within "#answer-#{answer.id}" do
        click_on 'like'
        click_on 'like'

        within '.answer-votes' do
          expect(page).to have_content '0'
          expect(page).not_to have_content '1'
        end
      end
    end
  end

  scenario "Author can't vote for his answer" do
    new_answer = create(:answer, question_id: question.id, user_id: user.id)

    visit question_path(question)

    within "#answer-#{new_answer.id}" do
      expect(page).not_to have_content 'like'
      expect(page).not_to have_content 'unlike'
    end
  end

  scenario "Unauthinticated user can't vote for question" do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).not_to have_content 'like'
      expect(page).not_to have_content 'unlike'
    end
  end
end
