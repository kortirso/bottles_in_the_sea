# frozen_string_literal: true

describe Api::V1::Users::AccessTokensController do
  describe 'POST#create' do
    context 'for unexisting user' do
      it 'returns error', :aggregate_failures do
        post :create, params: { user: { username: 'unexisting@gmail.com', password: '1' } }

        expect(response).to have_http_status :not_found
        expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).to be_blank
      end
    end

    context 'for existing user' do
      let!(:user) { create :user }

      context 'for invalid password' do
        it 'returns error', :aggregate_failures do
          post :create, params: { user: { username: user.username, password: 'invalid_password' } }

          expect(response).to have_http_status :bad_request
          expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).to be_blank
        end
      end

      context 'for empty password' do
        it 'returns error', :aggregate_failures do
          post :create, params: { user: { username: user.username, password: '' } }

          expect(response).to have_http_status :bad_request
          expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).to be_blank
        end
      end

      context 'for valid password' do
        it 'returns access token', :aggregate_failures do
          post :create, params: { user: { username: user.username, password: user.password } }

          expect(response).to have_http_status :created
          expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).not_to be_blank
        end
      end

      context 'for valid password and upcased username' do
        it 'returns access token', :aggregate_failures do
          post :create, params: { user: { username: user.username.upcase, password: user.password } }

          expect(response).to have_http_status :created
          expect(response.parsed_body.dig('user', 'data', 'attributes', 'access_token')).not_to be_blank
        end
      end
    end
  end
end
