require 'rails_helper'

describe 'User can add links to amswer', "
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:gist_url) { 'https://gist.github.com/nikitoooid/07ebe134f166003ac20825e5a291c5eb' }

  before do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'test answer body text'
  end

  it 'User adds link when answer the question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  it 'User tries to add link with invalid params', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'not valid url'

    click_on 'Answer'

    expect(page).not_to have_link 'My gist'
  end
end
