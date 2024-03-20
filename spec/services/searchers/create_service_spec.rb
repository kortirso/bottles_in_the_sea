# frozen_string_literal: true

describe Searchers::CreateService, type: :service do
  subject(:service_call) { described_class.call(world_id: world_id, params: params, cell_params: cell_params) }

  let!(:user) { create :user }
  let!(:world) { create :world }

  let(:world_id) { world.id }
  let(:params) { { user: user, name: 'Name' } }
  let(:cell_params) { { column: 0, row: 1 } }

  before do
    create :cell, world: world, surface: Cell::WATER, q: 0, r: 0
    create :cell, world: world, surface: Cell::GROUND, q: 0, r: 1
  end

  context 'for unexisting world' do
    let(:world_id) { 'unexisting' }

    it 'does not create new searcher' do
      expect { service_call }.not_to change(Searcher, :count)
    end

    it 'fails' do
      expect(service_call.failure?).to be_truthy
    end
  end

  context 'for water cell' do
    let(:cell_params) { { column: 0, row: 0 } }

    it 'does not create new searcher' do
      expect { service_call }.not_to change(Searcher, :count)
    end

    it 'fails' do
      expect(service_call.failure?).to be_truthy
    end
  end

  context 'for ground cell' do
    it 'creates new searcher' do
      expect { service_call }.to change(user.searchers, :count).by(1)
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end
end
