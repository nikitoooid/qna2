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
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end
      it 'render answer create js template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authenticated user' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'unauthenticated user' do
      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
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
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end