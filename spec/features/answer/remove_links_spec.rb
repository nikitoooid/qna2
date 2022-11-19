require 'rails_helper'

describe 'Author can remove links from his answer', "
  In order to correct my answer
  As an author of the answer
  I'd like to be able to remove links
", js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:link) { create(:link, linkable: answer) }

  it 'Author deletes the link' do
    sign_in(user)
    visit question_path(question)

    within ".link[data-id='#{link.id}']" do
      click_on 'delete'
    end

    expect(page).not_to have_selector(".link[data-id='#{link.id}']")
  end

  it 'Unauthenticated user tries to delete the link' do
    visit question_path(question)

    within ".link[data-id='#{link.id}']" do
      expect(page).not_to have_link 'delete'
    end
  end
end
