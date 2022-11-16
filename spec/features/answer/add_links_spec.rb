require 'rails_helper'

describe 'User can add links to amswer', "
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:gist_url) { 'https://gist.github.com/nikitoooid/07ebe134f166003ac20825e5a291c5eb' }

  it 'User adds link when answer the question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'test answer body text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
