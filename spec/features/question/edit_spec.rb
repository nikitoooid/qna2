require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    given(:another_user) { create(:user) }
    given(:another_question) { create(:question, user: another_user) }

    background do
      sign_in(user)
    end

    scenario 'edit his question with valid attributes' do
      visit question_path(question)

      click_on 'Edit'
      fill_in 'question[body]', with: 'edited question'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edit his question with errors' do
      visit question_path(question)

      click_on 'Edit'
      fill_in 'question[body]', with: nil

      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'
    end

    scenario "tries to edit someone else's question" do
      visit question_path(another_question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
