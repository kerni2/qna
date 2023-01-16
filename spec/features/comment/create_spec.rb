require 'rails_helper'

feature 'broadcasting comments', %q{} do

  describe 'multiple sessions', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question_id: question.id) }

    scenario "comment for question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-question-comment' do
          fill_in 'Body', with: 'Some comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Some comment'
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Some comment'
      end
    end

    scenario "comment for answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          fill_in 'Body', with: 'Some answer comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Some answer comment'
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Some answer comment'
      end
    end
  end
end
