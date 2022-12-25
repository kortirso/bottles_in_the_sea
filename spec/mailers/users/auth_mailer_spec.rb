# frozen_string_literal: true

describe Users::AuthMailer do
  let!(:user) { create :user }

  describe 'confirmation_email' do
    let(:mail) { described_class.confirmation_email(id: user.id) }

    it 'renders the headers', :aggregate_failures do
      expect(mail.subject).to eq(I18n.t('mailers.users.auth.confirmation_email.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@bottles.com'])
    end
  end

  describe 'password_restore_email' do
    let(:mail) { described_class.password_restore_email(id: user.id) }

    it 'renders the headers', :aggregate_failures do
      expect(mail.subject).to eq(I18n.t('mailers.users.auth.restore_email.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@bottles.com'])
    end
  end
end
