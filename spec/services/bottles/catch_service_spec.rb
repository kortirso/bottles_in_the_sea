# frozen_string_literal: true

describe Bottles::CatchService, type: :service do
  subject(:service_call) { instance.call(bottle: bottle, success_chance: success_chance) }

  let!(:instance) { described_class.new }

  let!(:cell) { create :cell, :ground }
  let!(:bottle) { create :bottle, cell: cell, end_cell: cell }
  let(:success_chance) { 0 }

  context 'when bottle can not be catched' do
    before { bottle.update(end_cell: nil) }

    it 'does not update bottle' do
      service_call

      expect(bottle.reload.cell_id).not_to be_nil
    end
  end

  context 'when bottle can be catched' do
    context 'when catching fails' do
      it 'does not update bottle' do
        service_call

        expect(bottle.reload.cell_id).not_to be_nil
      end
    end

    context 'when catching succeeds' do
      let(:success_chance) { 100 }

      context 'when there is no searcher' do
        it 'does not update bottle' do
          service_call

          expect(bottle.reload.cell_id).not_to be_nil
        end
      end

      context 'when there is searcher' do
        before { create :searcher, cell: cell }

        it 'updates bottle' do
          service_call

          expect(bottle.reload.cell_id).to be_nil
        end
      end
    end
  end
end
