# frozen_string_literal: true

describe Worlds::MassTickJob, type: :service do
  subject(:job_call) { described_class.perform_now }

  let!(:world) { create :world }

  before { allow(Worlds::TickJob).to receive(:perform_later) }

  it 'calls world tick job' do
    job_call

    expect(Worlds::TickJob).to have_received(:perform_later).with(id: world.id)
  end
end
