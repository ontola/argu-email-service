# frozen_string_literal: true
class EmailEventSerializer < ActiveModel::Serializer
  attributes :created_at, :event
end
