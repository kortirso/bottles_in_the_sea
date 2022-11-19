# frozen_string_literal: true

describe World do
  describe 'associations' do
    it { is_expected.to have_many(:cells).dependent(:destroy) }
    it { is_expected.to have_many(:bottles).through(:cells) }
  end
end
