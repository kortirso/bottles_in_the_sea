# frozen_string_literal: true

describe Bottles::CreateService, type: :service do
  subject(:service_call) { described_class.call(world_uuid: world_uuid, params: params, cell_params: cell_params) }

  let(:event_store) { Rails.configuration.event_store }
  let!(:user) { create :user }
  let!(:world) { create :world }

  let(:world_uuid) { world.uuid }
  let(:params) { { user: user } }
  let(:cell_params) { { column: 0, row: 0 } }

  before do
    create :cell, world: world, surface: Cell::WATER, q: 0, r: 0
    create :cell, world: world, surface: Cell::GROUND, q: 0, r: 1
  end

  it 'subscribes for events' do
    expect(Bottles::CreateJob).to have_subscribed_to_events(Bottles::CreatedEvent).in(event_store)
  end

  context 'for unexisting world' do
    let(:world_uuid) { 'unexisting' }

    it 'does not create new bottle' do
      expect { service_call }.not_to change(Bottle, :count)
    end

    it 'fails' do
      expect(service_call.failure?).to be_truthy
    end
  end

  context 'for ground cell' do
    let(:cell_params) { { column: 0, row: 1 } }

    it 'does not create new bottle' do
      expect { service_call }.not_to change(Bottle, :count)
    end

    it 'fails' do
      expect(service_call.failure?).to be_truthy
    end
  end

  context 'for water cell' do
    it 'creates new bottle' do
      expect { service_call }.to change(user.bottles, :count).by(1)
    end

    it 'publishes Bottles::CreatedEvent' do
      service_call

      expect(event_store).to(
        have_published(an_event(Bottles::CreatedEvent).with_data(bottle_uuid: Bottle.last.uuid))
      )
    end

    it 'succeeds' do
      expect(service_call.success?).to be_truthy
    end
  end
end
