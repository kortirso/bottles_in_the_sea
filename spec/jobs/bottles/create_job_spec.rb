# frozen_string_literal: true

describe Bottles::CreateJob, type: :service do
  subject(:job_call) { described_class.perform_now(id: id) }

  let!(:bottle) { create :bottle }

  before { allow(Achievement).to receive(:award) }

  context 'for unexisting bottle' do
    let(:id) { 'unexisting' }

    it 'does not call awarding' do
      job_call

      expect(Achievement).not_to have_received(:award)
    end
  end

  context 'for existing bottle' do
    let(:id) { bottle.id }

    it 'calls awarding' do
      job_call

      expect(Achievement).to have_received(:award).with(:bottle_create, bottle)
    end
  end
end
