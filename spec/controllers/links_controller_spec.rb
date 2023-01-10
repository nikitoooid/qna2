require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'when author is authenticated' do
      before { login(user) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when user is unauthenticated' do
      it 'not deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(Link, :count)
      end
    end
  end
end
