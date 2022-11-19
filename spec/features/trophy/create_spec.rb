require 'rails_helper'

feature 'User can create trophy for best answer', %q(
  In order to reward the answerer
  As the author of the question
  I'd like to able to create a trophy for the author of best answer
) do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'question[title]', with: 'Question title'
    fill_in 'question[body]', with: 'Question body'
  end

  it "Author creates a trophy for his question's best answer" do
    fill_in 'question[trophy_attributes][name]', with: 'Trophy name'
    attach_file 'question[trophy_attributes][image]', file_fixture('trophy.jpg')
    click_on 'Ask'

    within '.trophy' do
      expect(page).to have_selector("img[src$='trophy.jpg']")
      expect(page).to have_content('Trophy name')
    end
  end
end
