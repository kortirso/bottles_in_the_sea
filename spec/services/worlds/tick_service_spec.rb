# frozen_string_literal: true

describe Worlds::TickService, type: :service do
  subject(:service_call) {
    described_class
      .new(bottles_move_service: bottles_move_service, searchers_activate_service: searchers_activate_service)
      .call(world: world)
  }

  let(:bottles_move_service) { double }
  let(:searchers_activate_service) { double }
  let(:configuration) { double }
  let(:map_size) { { q: 2, r: 2 } }
  let!(:world) { create :world }
  let!(:ground_cell) { create :cell, q: 0, r: 0, surface: Cell::GROUND, world: world }
  let!(:water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER, world: world }
  let!(:another_ground_cell) { create :cell, q: 0, r: 2, surface: Cell::GROUND, world: world }
  let!(:ground_bottle) { create :bottle, cell: ground_cell, start_cell: ground_cell, end_cell: ground_cell }
  let!(:water_bottle) { create :bottle, cell: water_cell, start_cell: water_cell }
  let!(:another_world_water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER }
  let!(:another_world_water_bottle) {
    create :bottle, cell: another_world_water_cell, start_cell: another_world_water_cell
  }
  let!(:searcher) { create :searcher, cell: ground_cell }
  let!(:another_searcher) { create :searcher, cell: another_ground_cell }

  before do
    allow(Rails).to receive(:configuration).and_return(configuration)
    allow(configuration).to receive(:map_size).and_return(map_size)
    allow(configuration).to receive(:cell_type).and_return(:hexagon)

    allow(bottles_move_service).to receive(:call)
    allow(searchers_activate_service).to receive(:call)
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
    expect { service_call }.to change(world, :ticks).from(0).to(1)
  end

  it 'succeeds' do
    expect(service_call.success?).to be_truthy
  end

  context 'for parallel service calls' do
    subject(:thread_call) {
      threads = []
      threads << Thread.new { described_class.new(bottles_move_service: bottles_move_service).call(world: world) }
      threads << Thread.new { described_class.new(bottles_move_service: bottles_move_service).call(world: world) }
      threads.each(&:join)
    }

    it 'calls bottles_move_service only for bottles in the water cells', :aggregate_failures do
      thread_call

      expect(bottles_move_service).to have_received(:call).with(bottle: water_bottle).twice
      expect(bottles_move_service).not_to have_received(:call).with(bottle: ground_bottle)
      expect(bottles_move_service).not_to have_received(:call).with(bottle: another_world_water_bottle)
    end

    it 'updates world' do
      expect { thread_call }.to change(world, :ticks).from(0).to(2)
    end
  end
end
