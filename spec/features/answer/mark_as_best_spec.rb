require 'rails_helper'

feature 'Author can mark best answer to his question', %q{
  In order to show best solution of my problem
  As an author of the question
  I'd like be able to mark any answer as best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

	describe 'Authenticated user', js: true do
		given(:another_user) { create(:user) }

		describe 'tries to mark answer as best answer to his question' do
			
			before { sign_in(user) }

			scenario 'question has not best answer' do
				visit question_path(question)
				click_link 'Mark as best', href: "/answers/#{answers.last.id}/mark_as_best"

				expect(page).to have_css ".answer[data-id='#{answers.last.id}'].best-answer"
			end

			scenario 'question has best answer' do
				answers.first.mark_as_best
				visit question_path(question)
				click_link 'Mark as best', href: "/answers/#{answers.last.id}/mark_as_best"

				expect(page).to_not have_css ".answer[data-id='#{answers.first.id}'].best-answer"
				expect(page).to have_css ".answer[data-id='#{answers.last.id}'].best-answer"
			end
		end

		scenario "tries to mark answer as best answer to anyone else's question" do
			sign_in(another_user)
			visit question_path(question)

			expect(page).to_not have_content 'Mark as best'
		end
	end

	scenario 'Unauthenticated user tries to mark answer as best answer' do
		visit question_path(question)

		expect(page).to_not have_content 'Mark as best'
	end
end