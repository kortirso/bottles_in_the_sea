# frozen_string_literal: true

describe Bottle do
  describe 'associations' do
    it { is_expected.to belong_to(:cell) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:fish_out_user).class_name('User').optional }
  end
end
