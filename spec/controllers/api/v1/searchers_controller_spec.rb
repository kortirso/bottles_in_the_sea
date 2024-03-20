# frozen_string_literal: true

describe Api::V1::SearchersController do
  describe 'POST#create' do
    let!(:cell) { create :cell, :ground }

    it_behaves_like 'required api auth'

    context 'for logged users' do
      let!(:user) { create :user }
      let(:access_token) { Auth::GenerateTokenService.new.call(user: user)[:result] }

      context 'for not existing cell' do
        let(:request) {
          post :create, params: {
            searcher: { name: 'First' },
            cell: { column: cell.q, row: cell.r, world_id: 'unexisting' },
            api_access_token: access_token
          }
        }

        it 'does not create new searcher', :aggregate_failures do
          expect { request }.not_to change(Searcher, :count)
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'for existing cell and existing searcher' do
        let(:request) {
          post :create, params: {
            searcher: { name: 'First' },
            cell: { column: cell.q, row: cell.r, world_id: cell.world_id },
            api_access_token: access_token
          }
        }

        before { create :searcher, user: user }

        it 'does not create new searcher', :aggregate_failures do
          expect { request }.not_to change(Searcher, :count)
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'for existing cell' do
        let(:request) {
          post :create, params: {
            searcher: { name: 'First' },
            cell: { column: cell.q, row: cell.r, world_id: cell.world_id },
            api_access_token: access_token
          }
        }

        it 'creates new searcher', :aggregate_failures do
          expect { request }.to change(Searcher, :count)
          expect(response).to have_http_status :created
        end
      end
    end

    def do_request
      post :create, params: {
        searcher: { name: 'First' },
        cell: { column: cell.q, row: cell.r, world_id: 'unexisting' }
      }
    end
  end
end
