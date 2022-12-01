# frozen_string_literal: true

describe Searchers::ActivateService, type: :service do
  subject(:service_call) { described_class.new(success_chance: success_chance).call(searcher: searcher) }

  let!(:cell) { create :cell }
  let!(:searcher) { create :searcher, cell: cell }
  let!(:bottle) { create :bottle, cell: cell, end_cell: cell, fish_out_user: nil }

  context 'for success fishout' do
    let(:success_chance) { 100 }

    it 'updates bottle', :aggregate_failures do
      service_call

      expect(bottle.reload.cell).to be_nil
      expect(bottle.fish_out_user).to eq searcher.user
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end

  context 'for failed fishout' do
    let(:success_chance) { 0 }

    it 'does not update bottle', :aggregate_failures do
      service_call

      expect(bottle.reload.cell).to eq cell
      expect(bottle.fish_out_user).to be_nil
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end
end
