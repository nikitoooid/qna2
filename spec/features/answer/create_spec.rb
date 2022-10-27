require 'rails_helper'

feature 'User can create answer to the question', %{
  In order to help another user to find a solution
  As an authenticated user
  I'd like to be able to create the answer on the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Answer the question', with: 'Test answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Test answer'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Your answer not created!"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    fill_in 'Answer the question', with: 'Test answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
