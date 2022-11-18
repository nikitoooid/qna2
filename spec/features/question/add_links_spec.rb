require 'rails_helper'

describe 'User can add links to question', "
  In order to provide additional info to my question
  As an author of the question
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:gist_url) { 'https://gist.github.com/nikitoooid/07ebe134f166003ac20825e5a291c5eb' }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test question body text'
  end

  it 'User adds link when asks question' do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  it 'User tries to add link with invalid params' do
    fill_in 'Link name', with: 'My gist'

    click_on 'Ask'

    expect(page).not_to have_link 'My gist'
  end
end
