require 'rails_helper'

describe 'User can look at the question and its answers', "
  In order to get a solution to my problem
  As an user
  I'd like to be able to see the question and it's answers
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it 'User show the question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
