# frozen_string_literal: true

describe Bottle do
  it 'factory should be valid' do
    bottle = build :bottle

    expect(bottle).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cell) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:fish_out_user).class_name('User').optional }
  end
end
