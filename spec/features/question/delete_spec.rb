require 'rails_helper'

describe 'User can delete the question', %(
  In order to delete the question
  As an authenticated user
  I'd be able to delete my question
) do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, user: another_user) }

    before { sign_in(user) }

    it 'tries to delete his question' do
      visit question_path(question)

      click_link 'Delete question', href: "/questions/#{question.id}"

      expect(page).to have_content 'Your question successfully deleted'
      expect(page).not_to have_content question.body
    end

    it 'tries to delete someone anothers question' do
      visit question_path(another_question)

      expect(page).not_to have_link 'Delete question', href: "/questions/#{another_question.id}"
    end
  end

  it 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question', href: "/questions/#{question.id}"
  end
end
