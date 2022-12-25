# frozen_string_literal: true

describe Admin::BottlesController do
  let!(:bottle) { create :bottle }

  describe 'GET#index' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'
    it_behaves_like 'required admin'

    context 'for admin' do
      sign_in_admin

      it 'renders index template' do
        do_request

        expect(response).to render_template :index
      end
    end

    def do_request
      get :index, params: { locale: 'en' }
    end
  end

  describe 'POST#approve' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'
    it_behaves_like 'required admin'

    context 'for admin' do
      sign_in_admin

      context 'for not existing bottle' do
        it 'renders 404 page' do
          do_request

          expect(response).to render_template 'shared/404'
        end
      end

      context 'for existing bottle' do
        let(:request) { post :approve, params: { id: bottle.id, locale: 'en' } }

        it 'updates bottle' do
          expect { request }.to change { bottle.reload.moderated_at }.from(nil)
        end

        it 'redirects to index page' do
          request

          expect(response).to redirect_to admin_bottles_en_path
        end
      end
    end

    def do_request
      post :approve, params: { id: 'unexisting', locale: 'en' }
    end
  end

  describe 'DELETE#destroy' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'
    it_behaves_like 'required admin'

    context 'for admin' do
      sign_in_admin

      context 'for not existing bottle' do
        it 'renders 404 page' do
          do_request

          expect(response).to render_template 'shared/404'
        end
      end

      context 'for existing bottle' do
        let(:request) { delete :destroy, params: { id: bottle.id, locale: 'en' } }

        it 'deletes bottle' do
          expect { request }.to change(Bottle, :count).by(-1)
        end

        it 'redirects to index page' do
          request

          expect(response).to redirect_to admin_bottles_en_path
        end
      end
    end

    def do_request
      delete :destroy, params: { id: 'unexisting', locale: 'en' }
    end
  end
end
