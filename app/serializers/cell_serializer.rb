# frozen_string_literal: true

class CellSerializer < ApplicationSerializer
  attribute :id, if: proc { |_, params| required_field?(params, 'id') }, &:id
  attribute :q, if: proc { |_, params| required_field?(params, 'q') }, &:q
  attribute :r, if: proc { |_, params| required_field?(params, 'r') }, &:r
  attribute :surface, if: proc { |_, params| required_field?(params, 'surface') }, &:surface
end
