# frozen_string_literal: true

class ApplicationSerializer
  include JSONAPI::Serializer

  set_id :uuid
end
