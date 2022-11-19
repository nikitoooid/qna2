require 'rails_helper'

describe 'User can add links to amswer', "
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:gist_url) { 'https://gist.github.com/nikitoooid/07ebe134f166003ac20825e5a291c5eb' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe 'When user answer the question' do
    before { fill_in 'answer[body]', with: 'test answer body text' }

    it 'user adds link', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
  
      click_on 'Answer'
  
      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  
    it 'user tries to add link with invalid params', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'not valid url'
  
      click_on 'Answer'
  
      expect(page).not_to have_link 'My gist'
    end
  end

  describe 'When user edits the answer', js: true do
    before do
      within(".answers .answer[data-id='#{answer.id}']") do
        click_on 'Edit'
        click_on 'add link'
      end
    end

    it 'user adds link', js: true do
      within ".answers" do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'
  
        expect(page).not_to have_link 'My gist'
      end
    end

    it 'user tries to add link with invalid params', js: true do
      within ".answers" do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'not valid url'
  
        click_on 'Save'
  
        expect(page).not_to have_link 'My gist'
      end
    end
  end
end
