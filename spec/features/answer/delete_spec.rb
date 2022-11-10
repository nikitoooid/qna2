require 'rails_helper'

feature 'User can delete the answer', %{
  In order to delete the answer
  As an authenticated user
  I'd be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    given(:another_user) { create(:user) }
    given(:another_answer) { create(:answer, question: question, user: another_user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete his answer', js: true do
      click_link 'Delete answer', href: "/answers/#{answer.id}"
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      expect(page).to_not have_link 'Delete answer', href: "/answers/#{another_answer.id}"
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer', href: "/answers/#{answer.id}"
  end
end
