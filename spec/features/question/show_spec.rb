require 'rails_helper'

feature 'User can see question details and all answers on question page', %q{
  In order to see question and all answers
  As an everyone
  I'd like to be able to see question and all answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  background { visit question_path(question) }

  scenario 'User sees question' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User sees all the answers to the question' do
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
