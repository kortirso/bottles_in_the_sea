# frozen_string_literal: true

describe Api::V1::UsersController do
  describe 'POST#create' do
    context 'for invalid credentials' do
      let(:request) { post :create, params: { user: { username: '', password: '1' } } }

      it 'does not create user', :aggregate_failures do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'for short password' do
      let(:request) { post :create, params: { user: { username: 'user@gmail.com', password: '1' } } }

      it 'does not create new user', :aggregate_failures do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'without password confirmation' do
      let(:request) { post :create, params: { user: { username: 'user@gmail.com', password: '12345678' } } }

      it 'does not create new user', :aggregate_failures do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'for existing user' do
      let!(:user) { create :user }
      let(:request) {
        post :create, params: {
          user: { username: user.username, password: '12345678', password_confirmation: '12345678' }
        }
      }

      it 'does not create new user', :aggregate_failures do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'for valid data' do
      let(:user_params) { { username: ' useR@gmail.com ', password: '12345678', password_confirmation: '12345678' } }
      let(:request) { post :create, params: { user: user_params } }

      it 'creates new user', :aggregate_failures do
        expect { request }.to change(User, :count).by(1)
        expect(User.last.username).to eq 'user@gmail.com'
        expect(response).to have_http_status :created
        expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).not_to be_blank
      end
    end
  end
end
