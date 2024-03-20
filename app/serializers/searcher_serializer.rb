# frozen_string_literal: true

class SearcherSerializer < ApplicationSerializer
  attribute :id, if: proc { |_, params| required_field?(params, 'id') }, &:id
  attribute :name, if: proc { |_, params| required_field?(params, 'name') }, &:name
end
