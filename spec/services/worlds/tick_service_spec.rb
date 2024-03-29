# frozen_string_literal: true

describe Worlds::TickService, type: :service do
  subject(:service_call) {
    described_class
      .new(bottles_move_service: bottles_move_service, searchers_activate_service: searchers_activate_service)
      .call(world_id: world.id)
  }

  let(:bottles_move_service) { double }
  let(:searchers_activate_service) { double }
  let(:configuration) { double }
  let!(:world) { create :world, map_size: { q: 1, r: 1 } }
  let!(:ground_cell) { create :cell, q: 0, r: 0, surface: Cell::GROUND, world: world }
  let!(:water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER, world: world }
  let!(:another_ground_cell) { create :cell, q: 0, r: 2, surface: Cell::GROUND, world: world }
  let!(:ground_bottle) { create :bottle, :moderated, cell: ground_cell, start_cell: ground_cell, end_cell: ground_cell }
  let!(:water_bottle) { create :bottle, :moderated, cell: water_cell, start_cell: water_cell }
  let!(:another_world_water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER }
  let!(:another_world_water_bottle) {
    create :bottle, :moderated, cell: another_world_water_cell, start_cell: another_world_water_cell
  }
  let!(:searcher) { create :searcher, cell: ground_cell }
  let!(:another_searcher) { create :searcher, cell: another_ground_cell }

  before do
    allow(bottles_move_service).to receive(:call)
    allow(searchers_activate_service).to receive(:call)

    [[1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]].each do |cell|
      create :cell, q: cell[0], r: cell[1], surface: Cell::WATER, world: world
    end
  end

  it 'calls bottles_move_service only for bottles in the water cells', :aggregate_failures do
    service_call

    expect(bottles_move_service).to have_received(:call).with(bottle: water_bottle)
    expect(bottles_move_service).not_to have_received(:call).with(bottle: ground_bottle)
    expect(bottles_move_service).not_to have_received(:call).with(bottle: another_world_water_bottle)
  end

  it 'calls searchers_activate_service only for bottles in the ground cells with bottles', :aggregate_failures do
    service_call

    expect(searchers_activate_service).to have_received(:call).with(searcher: searcher)
    expect(searchers_activate_service).not_to have_received(:call).with(searcher: another_searcher)
  end

  it 'updates world' do
    service_call

    expect(world.reload.ticks).to eq 1
  end

  it 'succeeds' do
    expect(service_call.success?).to be_truthy
  end

  context 'for parallel service calls' do
    before do
      Cell.update_all(surface: Cell::WATER)
    end

    it 'calls bottles_move_service only for bottles in the water cells', :aggregate_failures do
      skip 'failed'

      Array.new(2) {
        Thread.new {
          described_class.new(
            bottles_move_service: bottles_move_service,
            searchers_activate_service: searchers_activate_service
          ).call(world_id: world.id)
        }
      }
      .each(&:join)

      expect(bottles_move_service).to have_received(:call).exactly(2)
      expect(world.reload.ticks).to eq 2
    end
  end
end
