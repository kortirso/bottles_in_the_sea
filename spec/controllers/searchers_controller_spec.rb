# frozen_string_literal: true

describe SearchersController do
  describe 'POST#create' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'

    context 'for logged users' do
      sign_in_user

      context 'for not existing world' do
        it 'does not create searcher' do
          expect { do_request }.not_to change(Searcher, :count)
        end

        it 'returns json unprocessable_entity status with errors' do
          do_request

          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'for existing world' do
        let!(:world) { create :world }

        context 'for not existing cell' do
          let(:request) {
            post :create, params: {
              world_uuid: world.uuid, cell: { column: 0, row: 0 }, searcher: { name: 'Name' }, locale: 'en'
            }
          }

          it 'does not create searcher' do
            expect { request }.not_to change(Searcher, :count)
          end

          it 'returns json unprocessable_entity status with errors' do
            request

            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context 'for existing cell' do
          let!(:cell) { create :cell, world: world, surface: Cell::GROUND, q: 0, r: 0 }
          let(:request) {
            post :create, params: {
              world_uuid: world.uuid, cell: { column: cell.q, row: cell.r }, searcher: { name: 'Name' }, locale: 'en'
            }
          }

          it 'creates searcher' do
            expect { request }.to change(@current_user.searchers, :count).by(1)
          end

          it 'returns json created status with errors' do
            request

            expect(response).to have_http_status :created
          end
        end
      end
    end

    def do_request
      post :create, params: {
        world_uuid: 'unexisting', cell: { column: 0, row: 0 }, searcher: { name: '' }, locale: 'en'
      }
    end
  end
end
