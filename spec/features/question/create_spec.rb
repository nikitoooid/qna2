require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an authenticate user
  I'd like to be able to ask the question
" do
  let(:user) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    it 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test text'
    end

    it 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'asks a question with errors' do
      fill_in 'Title', with: 'Test question'
      click_on 'Ask'

      expect(page).to have_content "Body can't be blank"
    end
  end

  it 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
