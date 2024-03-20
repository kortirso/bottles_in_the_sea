# frozen_string_literal: true

class WorldSerializer < ApplicationSerializer
  attribute :id, if: proc { |_, params| required_field?(params, 'id') }, &:id
  attribute :ticks, if: proc { |_, params| required_field?(params, 'ticks') }, &:ticks
  attribute :map_size, if: proc { |_, params| required_field?(params, 'map_size') }, &:map_size

  attribute :name, if: proc { |_, params| required_field?(params, 'name') } do |object|
    object.name ? object.name[I18n.locale.to_s] : nil
  end
end
