require 'rails_helper'

describe 'User can add links to question', "
  In order to provide additional info to my question
  As an author of the question
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:gist_url) { 'https://gist.github.com/nikitoooid/07ebe134f166003ac20825e5a291c5eb' }

  before do
    sign_in(user)
  end

  describe 'When user creates the question' do
    before do
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test question body text'
    end

    it 'user adds link' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    it 'user tries to add link with invalid params' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'not valid url'

      click_on 'Ask'

      expect(page).not_to have_link 'My gist'
      expect(page).to have_content 'Url is not valid'
    end
  end

  describe 'When user edits the question', js: true do
    before do
      visit question_path(question)

      click_on 'Edit'
      click_on 'add link'
    end

    it 'User adds link' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url
    end

    it 'User tries to add link with invalid params' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'not valid url'

      click_on 'Save'

      expect(page).not_to have_link 'My gist'
      expect(page).to have_content 'Url is not valid'
    end
  end
end
