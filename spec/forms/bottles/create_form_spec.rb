# frozen_string_literal: true

describe Bottles::CreateForm, type: :service do
  subject(:form) { instance.call(params: params, cell_params: cell_params) }

  let!(:instance) { described_class.new }

  let!(:user) { create :user }
  let!(:world) { create :world }

  let(:world_id) { world.id }
  let(:params) { { user: user } }
  let(:cell_params) { { column: 0, row: 0, world_id: world_id } }

  before do
    create :cell, world: world, surface: Cell::WATER, q: 0, r: 0
    create :cell, world: world, surface: Cell::GROUND, q: 0, r: 1
  end

  context 'for unexisting world' do
    let(:world_id) { 'unexisting' }

    it 'does not create new bottle', :aggregate_failures do
      expect { form }.not_to change(Bottle, :count)
      expect(form[:errors]).not_to be_blank
    end
  end

  context 'for ground cell' do
    let(:cell_params) { { column: 0, row: 1 } }

    it 'does not create new bottle', :aggregate_failures do
      expect { form }.not_to change(Bottle, :count)
      expect(form[:errors]).not_to be_blank
    end
  end

  context 'for water cell' do
    it 'creates new bottle', :aggregate_failures do
      expect { form }.to change(user.bottles, :count).by(1)
      expect(form[:errors]).to be_blank
    end
  end
end
