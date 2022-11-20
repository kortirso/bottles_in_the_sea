# frozen_string_literal: true

describe Searcher do
  it 'factory should be valid' do
    searcher = build :searcher

    expect(searcher).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:cell).optional }
  end
end
