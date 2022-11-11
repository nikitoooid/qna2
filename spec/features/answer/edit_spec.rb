require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't edit answers" do
    visit question_path(question)
    
    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user', js: true do

    given(:another_user) { create(:user) }
    given!(:another_answer) { create(:answer, question: question, user: another_user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit his answer with valid attributes' do
      within (".answers .answer[data-id='#{answer.id}']") do
        click_on 'Edit'
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within (".answers .answer[data-id='#{answer.id}']") do
        click_on 'Edit'
        fill_in 'answer[body]', with: nil
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit someone else's answer" do
      within (".answers .answer[data-id='#{another_answer.id}']") do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
