# frozen_string_literal: true

require 'dry/auto_inject'
require 'dry/container'

module BottlesInTheSea
  class Container
    extend Dry::Container::Mixin

    DEFAULT_OPTIONS = { memoize: true }.freeze

    class << self
      def register(key)
        super(key, DEFAULT_OPTIONS)
      end
    end

    register('jwt_encoder') { JwtEncoder.new }

    # contracts
    register('contracts.users.create') { Users::CreateContract.new }

    # validators
    register('validators.users.create') { Users::CreateValidator.new }

    # forms
    register('forms.users.create') { Users::CreateForm.new }
    register('forms.bottles.create') { Bottles::CreateForm.new }
    register('forms.searchers.create') { Searchers::CreateForm.new }

    # services
    register('services.auth.fetch_session') { Auth::FetchSessionService.new }
    register('services.auth.generate_token') { Auth::GenerateTokenService.new }

    # queries
    register('queries.cells') { CellsQuery.new }
  end
end

Deps = Dry::AutoInject(BottlesInTheSea::Container)
