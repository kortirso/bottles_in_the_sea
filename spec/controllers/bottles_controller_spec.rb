# frozen_string_literal: true

describe BottlesController do
  describe 'POST#create' do
    it_behaves_like 'required auth'
    it_behaves_like 'required email confirmation'

    context 'for logged users' do
      sign_in_user

      context 'for not existing world' do
        it 'does not create bottle' do
          expect { do_request }.not_to change(Bottle, :count)
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
              world_uuid: world.uuid, cell: { column: 0, row: 0 }, bottle: { form: 'bordeaux' }, locale: 'en'
            }
          }

          it 'does not create bottle' do
            expect { request }.not_to change(Bottle, :count)
          end

          it 'returns json unprocessable_entity status with errors' do
            request

            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context 'for existing cell' do
          let!(:cell) { create :cell, world: world, surface: Cell::WATER, q: 0, r: 0 }
          let(:request) {
            post :create, params: {
              world_uuid: world.uuid, cell: { column: cell.q, row: cell.r }, bottle: { form: 'bordeaux' }, locale: 'en'
            }
          }

          it 'creates bottle' do
            expect { request }.to change(@current_user.bottles, :count).by(1)
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
        world_uuid: 'unexisting', cell: { column: 0, row: 0 }, bottle: { form: '' }, locale: 'en'
      }
    end
  end
end
