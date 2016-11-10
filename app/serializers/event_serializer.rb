# frozen_string_literal: true
class EventSerializer < ActiveModel::Serializer
  attributes :created_at, :event
end
