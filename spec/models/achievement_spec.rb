# frozen_string_literal: true

describe Achievement do
  describe 'awarding' do
    let!(:user) { create :user }
    let!(:bottle) { create :bottle, user: user }

    context 'for bottle_create' do
      before do
        create :kudos_achievement, award_name: 'bottle_create', rank: 1
        create :kudos_achievement, award_name: 'bottle_create', rank: 2, points: 10
      end

      it 'awards user' do
        expect { described_class.award(:bottle_create, bottle) }.to(
          change(Kudos::Users::Achievement, :count).by(1)
        )
      end
    end
  end
end
