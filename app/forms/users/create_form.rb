# frozen_string_literal: true

module Users
  class CreateForm
    include Deps[validator: 'validators.users.create']

    def call(params:)
      errors = validator.call(params: params)
      return { errors: errors } if errors.any?

      { result: User.create!(params) }
    rescue ActiveRecord::RecordNotUnique
      { errors: ['User is not unique'] }
    end
  end
end
