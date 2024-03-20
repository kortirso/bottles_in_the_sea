# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  extend Helpers::AccessToken

  set_id { SecureRandom.hex }

  attribute :username, if: proc { |_, params| required_field?(params, 'username') }, &:username

  attribute :access_token, if: proc { |_, params| required_field?(params, 'access_token') } do |object|
    generate_token_service.call(user: object)[:result]
  end
end
