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
    given(:edit_question) do
      visit question_path(question)
      click_on 'Edit'
      
      fill_in 'Body', with: 'edited question'
    end

    background do
      sign_in(user)
    end

    scenario 'edit his question with valid attributes' do
      edit_question

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edit his question with valid attributes and files' do
      edit_question
      attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
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
