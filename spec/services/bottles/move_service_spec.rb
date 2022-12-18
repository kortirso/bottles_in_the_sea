# frozen_string_literal: true

describe Bottles::MoveService, type: :service do
  subject(:service_call) { described_class.call(bottle: bottle) }

  let(:map_size) { { q: 2, r: 2 } }
  let!(:world) { create :world, map_size: map_size, cell_type: World::HEXAGON }
  let!(:cells) {
    (0..2).flat_map do |q|
      (0..2).map do |r|
        create :cell, q: q, r: r, surface: (q.zero? && r.zero? ? Cell::GROUND : Cell::WATER), world: world
      end
    end
  }
  let(:bottle) { create :bottle, cell: cell, start_cell: cell }

  context 'for ground cell' do
    let(:cell) { cells.find { |cell| cell.q.zero? && cell.r.zero? } }

    it 'does not update cell for bottle' do
      expect { service_call }.not_to change(bottle.reload, :cell_id)
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end

  context 'for water cell with slow flows' do
    let(:cell) { cells.find { |cell| cell.q == 1 && cell.r == 1 } }

    before do
      cell.update(flows: {})
    end

    it 'does not update cell for bottle' do
      expect { service_call }.not_to change(bottle.reload, :cell_id)
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end

  context 'for water cell not on the border of map' do
    let(:cell) { cells.find { |cell| cell.q == 1 && cell.r == 1 } }

    it 'updates cell for bottle' do
      expect { service_call }.to change(bottle.reload, :cell_id)
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end

  context 'for water cell on the top border of map' do
    let(:cell) { cells.find { |cell| cell.q == 1 && cell.r.zero? } }

    before do
      cell.update(flows: { '0' => 100 })
    end

    it 'updates cell for bottle' do
      expect { service_call }.to(
        change(bottle.reload, :cell_id).to(cells.find { |cell| cell.q == 2 && cell.r == 0 }.id)
      )
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end

  context 'for water cell on the left border of map' do
    let(:cell) { cells.find { |cell| cell.q.zero? && cell.r == 1 } }

    before do
      cell.update(flows: { '4' => 100 })
    end

    it 'updates cell for bottle' do
      expect { service_call }.to(
        change(bottle.reload, :cell_id).to(cells.find { |cell| cell.q == 2 && cell.r == 1 }.id)
      )
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end
end
