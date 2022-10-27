require 'rails_helper'

feature 'User can look at the list of all questions', %q{
  In order to find the solution
  As a user
  I'd like to be able to get the list of all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario 'User gets the list of all questions' do
    visit questions_path

    questions.each { |q| expect(page).to have_content q.title }
  end
end
