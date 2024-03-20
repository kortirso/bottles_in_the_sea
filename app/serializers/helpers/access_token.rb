# frozen_string_literal: true

module Helpers
  module AccessToken
    def generate_token_service
      BottlesInTheSea::Container['services.auth.generate_token']
    end
  end
end
