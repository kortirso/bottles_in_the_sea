# frozen_string_literal: true

describe Flows::TickService, type: :service do
  subject(:service_call) { described_class.new(bottles_move_service: bottles_move_service).call }

  let(:bottles_move_service) { double }
  let(:configuration) { double }
  let(:map_size) { { q: 2, r: 2 } }
  let!(:ground_cell) { create :cell, q: 0, r: 0, surface: Cell::GROUND }
  let!(:water_cell) { create :cell, q: 0, r: 1, surface: Cell::WATER }
  let!(:ground_bottle) { create :bottle, cell: ground_cell }
  let!(:water_bottle) { create :bottle, cell: water_cell }

  before do
    allow(Rails).to receive(:configuration).and_return(configuration)
    allow(configuration).to receive(:map_size).and_return(map_size)
    allow(configuration).to receive(:cell_type).and_return(:hexagon)

    allow(bottles_move_service).to receive(:call)
  end

  it 'calls bottles_move_service only for bottles in the water cells', :aggregate_failures do
    service_call

    expect(bottles_move_service).to have_received(:call).with(bottle: water_bottle)
    expect(bottles_move_service).not_to have_received(:call).with(bottle: ground_bottle)
  end

  it 'succeeds' do
    expect(service_call.success?).to be_truthy
  end
end
