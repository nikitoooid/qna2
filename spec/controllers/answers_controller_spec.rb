require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render answer create js template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.not_to change(Answer, :count)
      end

      it 'render answer create js template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'when author is authenticated' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        render_template :destroy
      end
    end

    context 'when user is unauthenticated' do
      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not update the answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:mark_as_best_answer) { patch :mark_as_best, params: { id: answer }, format: :js }

    context 'when author of the question is authenticated' do
      before { login(user) }

      it "changes question's best answer" do
        mark_as_best_answer
        expect(question.reload.best_answer_id).to eq answer.id
      end

      it 'renders from mark_as_best view' do
        mark_as_best_answer
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when another user is authenticated' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it "does not change question's best answer in database" do
        expect { mark_as_best_answer }.not_to change(question, :best_answer_id)
      end

      it 'renders from mark_as_best view' do
        mark_as_best_answer
        expect(response).to render_template :mark_as_best
      end
    end
  end
end
