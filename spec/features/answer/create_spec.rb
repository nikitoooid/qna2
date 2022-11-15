require 'rails_helper'

describe 'User can create answer to the question', %(
  In order to help another user to find a solution
  As an authenticated user
  I'd like to be able to create the answer on the question page
), js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)

      visit question_path(question)
    end

    it 'answers the question', js: true do
      fill_in 'Answer the question', with: 'Test answer'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    it 'asks a question with attached files' do
      fill_in 'Answer the question', with: 'Test answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    it 'answers the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  it 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    fill_in 'Answer the question', with: 'Test answer for unauthenicated user'
    click_on 'Answer'

    expect(page).not_to have_content 'Test answer for unauthenicated user'
  end
end
