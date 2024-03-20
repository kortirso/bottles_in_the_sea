# frozen_string_literal: true

describe Api::V1::CellsController do
  describe 'GET#index' do
    it_behaves_like 'required api auth'

    context 'for logged users' do
      let!(:user) { create :user }
      let!(:world) { create :world }
      let(:access_token) { Auth::GenerateTokenService.new.call(user: user)[:result] }

      before { create :cell, world_id: world.id }

      it 'returns cells data', :aggregate_failures do
        get :index, params: { world_id: world.id, api_access_token: access_token }

        expect(response).to have_http_status :ok

        attributes = response.parsed_body.dig('cells', 'data', 0, 'attributes')
        expect(attributes['id']).not_to be_nil
        expect(attributes['q']).not_to be_nil
        expect(attributes['r']).not_to be_nil
        expect(attributes['surface']).not_to be_nil
      end

      context 'for unexisting world' do
        it 'returns empty cells data', :aggregate_failures do
          get :index, params: { world_id: 'unexisting', api_access_token: access_token }

          expect(response).to have_http_status :ok
          expect(response.parsed_body.dig('cells', 'data').size).to eq 0
        end
      end
    end

    def do_request
      get :index, params: { world_id: 'unexisting' }
    end
  end
end
