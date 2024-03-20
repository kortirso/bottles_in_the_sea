# frozen_string_literal: true

describe Api::V1::BottlesController do
  describe 'POST#create' do
    let!(:cell) { create :cell }

    it_behaves_like 'required api auth'

    context 'for logged users' do
      let!(:user) { create :user }
      let(:access_token) { Auth::GenerateTokenService.new.call(user: user)[:result] }

      context 'for not existing cell' do
        let(:request) {
          post :create, params: {
            bottle: { form: Bottle::BORDEAUX },
            cell: { column: cell.q, row: cell.r, world_id: 'unexisting' },
            api_access_token: access_token
          }
        }

        it 'does not create new user', :aggregate_failures do
          expect { request }.not_to change(Bottle, :count)
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'for existing cell' do
        let(:request) {
          post :create, params: {
            bottle: { form: Bottle::BORDEAUX },
            cell: { column: cell.q, row: cell.r, world_id: cell.world_id },
            api_access_token: access_token
          }
        }

        it 'creates new user', :aggregate_failures do
          expect { request }.to change(Bottle, :count)
          expect(Bottle.last.created_at_tick).to eq cell.world.ticks
          expect(response).to have_http_status :created
        end
      end
    end

    def do_request
      post :create, params: {
        bottle: { form: Bottle::BORDEAUX },
        cell: { column: cell.q, row: cell.r, world_id: 'unexisting' }
      }
    end
  end
end
