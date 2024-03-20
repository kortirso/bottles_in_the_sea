# frozen_string_literal: true

class BottleSerializer < ApplicationSerializer
  attribute :id, if: proc { |_, params| required_field?(params, 'id') }, &:id
  attribute :form, if: proc { |_, params| required_field?(params, 'form') }, &:form
end
