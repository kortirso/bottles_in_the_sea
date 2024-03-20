# frozen_string_literal: true

describe Bottle do
  it 'factory should be valid' do
    bottle = build :bottle

    expect(bottle).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cell).optional }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:fish_out_user).class_name('User').optional }
  end

  describe 'moderated?' do
    let!(:bottle) { create :bottle, :moderated }

    context 'when is moderated' do
      it 'returns true' do
        expect(bottle.moderated?).to be_truthy
      end
    end

    context 'when is not moderated' do
      before { bottle.update!(moderated_at: nil) }

      it 'returns false' do
        expect(bottle.moderated?).to be_falsy
      end
    end
  end

  describe '.sailing_duration' do
    let!(:world) { create :world, ticks: 123 }
    let!(:cell) { create :cell, world: world }
    let!(:bottle) { create :bottle, cell: cell, start_cell: cell }

    context 'for not fished out bottle' do
      it 'returns current ticks' do
        expect(bottle.sailing_duration).to eq 123
      end
    end

    context 'for fished out bottle' do
      before { bottle.update!(fish_out_at_tick: 13) }

      it 'returns sailing duration ticks' do
        expect(bottle.sailing_duration).to eq 13
      end
    end
  end
end
