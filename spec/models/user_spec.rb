# frozen_string_literal: true

describe User do
  it 'factory should be valid' do
    user = build :user

    expect(user).to be_valid
  end

  it { is_expected.to define_enum_for :role }

  describe 'associations' do
    it { is_expected.to have_one(:users_session).class_name('::Users::Session').dependent(:destroy) }
    it { is_expected.to have_many(:bottles).with_foreign_key(:user_id).dependent(:nullify) }

    it {
      is_expected.to(
        have_many(:fish_out_bottles).class_name('Bottle').with_foreign_key(:fish_out_user_id).dependent(:nullify)
      )
    }
  end

  describe 'roles' do
    let!(:user) { create :user, role: 0 }

    context 'for regular role' do
      it 'returns true for regular matching' do
        expect(user.regular?).to be_truthy
      end

      it 'returns false for admin matching' do
        expect(user.admin?).to be_falsy
      end
    end

    context 'for admin role' do
      before { user.update!(role: 1) }

      it 'returns false for regular matching' do
        expect(user.regular?).to be_falsy
      end

      it 'returns true for admin matching' do
        expect(user.admin?).to be_truthy
      end
    end
  end

  describe 'confirmed?' do
    let!(:user) { create :user }

    context 'when is confirmed' do
      it 'returns true' do
        expect(user.confirmed?).to be_truthy
      end
    end

    context 'when is not confirmed' do
      before { user.update!(confirmed_at: nil) }

      it 'returns false' do
        expect(user.confirmed?).to be_falsy
      end
    end
  end
end
