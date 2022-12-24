# frozen_string_literal: true

describe Worlds::BottleFormsController do
  describe 'GET#index' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'

    context 'for logged users' do
      sign_in_user

      context 'for not existing world' do
        it 'returns json unprocessable_entity status with errors' do
          do_request

          expect(response).to have_http_status :not_found
        end
      end

      context 'for existing world' do
        let!(:world) { create :world }

        it 'returns status 200' do
          get :index, params: { world_id: world.uuid, locale: 'en' }

          expect(response).to have_http_status :ok
        end
      end
    end

    def do_request
      get :index, params: { world_id: 'unexisting', locale: 'en' }
    end
  end
end
