require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    given(:another_user) { create(:user) }
    given(:another_question) { create(:question, user: another_user) }
    given(:edit_question) do
      visit question_path(question)
      click_on 'Edit'
      
      fill_in 'Body', with: 'edited question'
    end
    given(:file) do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "Test file")
      question.files.last
    end
    given(:another_file) do
      another_question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "Test file")
      another_question.files.last
    end

    background do
      sign_in(user)
    end

    scenario 'edit his question with valid attributes' do
      edit_question

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edit his question with valid attributes and files' do
      edit_question
      attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'deletes the question attachment' do
      file
      visit question_path(question)
      click_link '| Delete', href: "/attachments/#{file.id}"

      expect(page).to have_content 'Test file'
    end

    scenario 'edit his question with errors' do
      visit question_path(question)

      click_on 'Edit'
      fill_in 'question[body]', with: nil

      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'
    end

    scenario "tries to edit someone else's question" do
      visit question_path(another_question)
      expect(page).to_not have_link 'Edit'
    end

    scenario "tries to delete someone else's question attachment" do
      another_file
      visit question_path(another_question)

      expect(page).to have_content 'Test file'
      expect(page).to_not have_link '| Delete', href: "/attachments/#{another_file.id}"
    end
  end
end
