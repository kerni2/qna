require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, author: user) }
  given(:gist_url) { 'https://gist.github.com/kerni2/36e1d17e7764bb003727496feb417c1d' }

  scenario 'User adds links when create answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'answer[body]', with: 'Some Body'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add Answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
