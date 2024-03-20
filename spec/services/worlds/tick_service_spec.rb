# frozen_string_literal: true

describe Worlds::TickService, type: :service do
  subject(:service_call) { instance.call(world_id: world_id) }

  let!(:instance) { described_class.new }

  let!(:move_service) { BottlesInTheSea::Container.resolve('services.bottles.move') }
  let!(:catch_service) { BottlesInTheSea::Container.resolve('services.bottles.catch') }

  let!(:world) { create :world, map_size: { q: 1, r: 1 } }
  let!(:ground_cell) { create :cell, q: 0, r: 0, surface: Cell::GROUND, world: world }
  let!(:water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER, world: world }
  let!(:ground_bottle) { create :bottle, :moderated, cell: ground_cell, start_cell: ground_cell, end_cell: ground_cell }
  let!(:water_bottle) { create :bottle, :moderated, cell: water_cell, start_cell: water_cell }
  let!(:another_world_water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER }
  let!(:another_world_water_bottle) {
    create :bottle, :moderated, cell: another_world_water_cell, start_cell: another_world_water_cell
  }

  before do
    allow(move_service).to receive(:call)
    allow(catch_service).to receive(:call)

    [[1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]].each do |cell|
      create :cell, q: cell[0], r: cell[1], surface: Cell::WATER, world: world
    end
  end

  context 'for unexisting world' do
    let(:world_id) { 'unexisting' }

    it 'does not update world' do
      service_call

      expect(world.reload.ticks).to eq 0
    end
  end

  context 'for existing world' do
    let(:world_id) { world.id }

    it 'calls catch service only for bottles in the ground cells with bottles', :aggregate_failures do
      service_call

      expect(world.reload.ticks).to eq 1

      expect(move_service).to have_received(:call).with(bottle: water_bottle)
      expect(move_service).not_to have_received(:call).with(bottle: ground_bottle)
      expect(move_service).not_to have_received(:call).with(bottle: another_world_water_bottle)

      expect(catch_service).not_to have_received(:call).with(bottle: water_bottle)
      expect(catch_service).to have_received(:call).with(bottle: ground_bottle)
      expect(catch_service).not_to have_received(:call).with(bottle: another_world_water_bottle)
    end
  end
end
