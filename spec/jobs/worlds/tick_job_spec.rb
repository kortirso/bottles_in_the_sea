# frozen_string_literal: true

describe Worlds::TickJob, type: :service do
  subject(:job_call) { described_class.perform_now(id: id) }

  let!(:world) { create :world }
  let!(:tick_service) { BottlesInTheSea::Container.resolve('services.worlds.tick') }

  before { allow(tick_service).to receive(:call) }

  context 'for unexisting world' do
    let(:id) { 'unexisting' }

    it 'calls world tick' do
      job_call

      expect(tick_service).to have_received(:call).with(world_id: 'unexisting')
    end
  end

  context 'for existing world' do
    let(:id) { world.id }

    it 'calls world tick' do
      job_call

      expect(tick_service).to have_received(:call).with(world_id: id)
    end
  end
end
