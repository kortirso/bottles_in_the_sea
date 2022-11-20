# frozen_string_literal: true

describe CellsController do
  describe 'GET#index' do
    let!(:world) { create :world }

    before do
      create_list :cell, 2, world: world, surface: Cell::GROUND

      get :index, params: { world_uuid: world.uuid, locale: 'en' }
    end

    it 'returns status 200' do
      expect(response).to have_http_status :ok
    end

    %w[uuid q r surface].each do |attr|
      it "contains cell #{attr}" do
        expect(response.body).to have_json_path("cells/data/0/attributes/#{attr}")
      end
    end
  end
end
