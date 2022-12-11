require 'rails_helper'

feature 'User can see all questions', %q{
  In order to find an interesting question
  As an everyone
  I'd like to be able to see all questions list
} do

  scenario 'User sees all questions' do
    questions = Question.all

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
