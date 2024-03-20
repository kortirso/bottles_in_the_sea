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
end
