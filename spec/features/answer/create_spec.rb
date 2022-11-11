require 'rails_helper'

feature 'User can create answer to the question', %{
  In order to help another user to find a solution
  As an authenticated user
  I'd like to be able to create the answer on the question page
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Answer the question', with: 'Test answer'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    fill_in 'Answer the question', with: 'Test answer for unauthenicated user'
    click_on 'Answer'

    expect(page).to_not have_content 'Test answer for unauthenicated user'
  end

end
