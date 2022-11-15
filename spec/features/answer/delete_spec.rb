require 'rails_helper'

describe 'User can delete the answer', %(
  In order to delete the answer
  As an authenticated user
  I'd be able to delete my answer
) do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    let(:another_user) { create(:user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'tries to delete his answer', js: true do
      click_link 'Delete answer', href: "/answers/#{answer.id}"
      expect(page).not_to have_content answer.body
    end

    it "tries to delete someone else's answer" do
      expect(page).not_to have_link 'Delete answer', href: "/answers/#{another_answer.id}"
    end
  end

  it 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Delete answer', href: "/answers/#{answer.id}"
  end
end
