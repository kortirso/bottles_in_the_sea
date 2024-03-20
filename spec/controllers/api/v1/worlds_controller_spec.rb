# frozen_string_literal: true

describe Api::V1::WorldsController do
  describe 'GET#index' do
    it_behaves_like 'required api auth'

    context 'for logged users' do
      let!(:user) { create :user }
      let(:access_token) { Auth::GenerateTokenService.new.call(user: user)[:result] }

      before { create :world }

      it 'returns worlds data', :aggregate_failures do
        get :index, params: { api_access_token: access_token }

        expect(response).to have_http_status :ok

        attributes = response.parsed_body.dig('worlds', 'data', 0, 'attributes')
        expect(attributes['id']).not_to be_nil
        expect(attributes['ticks']).not_to be_nil
        expect(attributes['name']).not_to be_nil
        expect(attributes['map_size']).not_to be_nil
      end
    end

    def do_request
      get :index
    end
  end
end
