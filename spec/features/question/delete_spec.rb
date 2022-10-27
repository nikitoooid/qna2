require 'rails_helper'

feature 'User can delete the question', %{
  In order to delete the question
  As an authenticated user
  I'd be able to delete my question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }


  describe 'Authenticated user' do
    given(:another_user) { create(:user) }
    given(:another_question) { create(:question, user: another_user) }
    
    background { sign_in(user) }

    scenario 'tries to delete his question' do
      visit question_path(question)

      click_link 'Delete question', href: "/questions/#{question.id}"

      expect(page).to have_content 'Your question successfully deleted'
      expect(page).not_to have_content question.body
    end

    scenario 'tries to delete someone anothers question' do
      visit question_path(another_question)

      expect(page).to_not have_link 'Delete question', href: "/questions/#{another_question.id}"
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question', href: "/questions/#{question.id}"
  end
end
