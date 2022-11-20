# frozen_string_literal: true

describe World do
  it 'factory should be valid' do
    world = build :world

    expect(world).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:cells).dependent(:destroy) }
    it { is_expected.to have_many(:bottles).through(:cells) }
  end
end
