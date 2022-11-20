# frozen_string_literal: true

describe Cell do
  it 'factory should be valid' do
    cell = build :cell

    expect(cell).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:world) }
    it { is_expected.to have_many(:bottles).dependent(:destroy) }
  end
end
