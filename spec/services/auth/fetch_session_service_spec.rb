# frozen_string_literal: true

describe Auth::FetchSessionService do
  subject(:service_call) { described_class.new.call(token: token) }

  context 'for valid token' do
    let(:token) { JwtEncoder.new.encode(payload: { uuid: session_uuid }) }

    context 'for unexisted session' do
      let(:session_uuid) { 'random uuid' }

      it 'does not assign user' do
        expect(service_call[:result]).to be_nil
      end
    end

    context 'for existed session' do
      let(:users_session) { create :users_session }
      let(:session_uuid) { users_session.uuid }

      it 'assigns user' do
        expect(service_call[:result]).to eq users_session
      end
    end
  end

  context 'for invalid token' do
    let(:token) { 'random uuid' }

    it 'does not assign user' do
      expect(service_call[:result]).to be_nil
    end
  end
end
