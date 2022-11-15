require 'rails_helper'

describe 'User can edit his answer', "
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it "Unauthenticated user can't edit answers" do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Edit answer'
    end
  end

  describe 'Authenticated user', js: true do
    let(:another_user) { create(:user) }
    let!(:another_answer) { create(:answer, question: question, user: another_user) }
    let(:edit_answer) do
      click_on 'Edit'
      fill_in 'answer[body]', with: 'edited answer'
    end
    let(:file) do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'Test file')
      answer.files.last
    end
    let(:another_file) do
      another_answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'Test file')
      another_answer.files.last
    end

    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'edit his answer with valid attributes' do
      within(".answers .answer[data-id='#{answer.id}']") do
        edit_answer
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'edit his answer with valid attributes and files' do
      within(".answers .answer[data-id='#{answer.id}']") do
        edit_answer
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'deletes the answer attachment' do
      file
      visit question_path(question)
      within(".answers .answer[data-id='#{answer.id}']") do
        click_link '| Delete', href: "/attachments/#{file.id}"

        expect(page).to have_content 'Test file'
      end
    end

    it 'edit his answer with errors' do
      within(".answers .answer[data-id='#{answer.id}']") do
        click_on 'Edit'
        fill_in 'answer[body]', with: nil
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    it "tries to edit someone else's answer" do
      within(".answers .answer[data-id='#{another_answer.id}']") do
        expect(page).not_to have_link 'Edit'
      end
    end

    it "tries to delete someone else's question attachment" do
      another_file
      visit question_path(question)

      within(".answers .answer[data-id='#{another_answer.id}']") do
        expect(page).to have_content 'Test file'
        expect(page).not_to have_link '| Delete', href: "/attachments/#{another_file.id}"
      end
    end
  end
end
