# frozen_string_literal: true

describe Cell do
  describe 'associations' do
    it { is_expected.to belong_to(:world) }
    it { is_expected.to have_many(:bottles).dependent(:destroy) }
  end
end
