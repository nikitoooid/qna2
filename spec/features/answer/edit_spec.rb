require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit his answer with valid attributes' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do

    end

    scenario "tries to edit someone else's answer" do

    end
  end
end
