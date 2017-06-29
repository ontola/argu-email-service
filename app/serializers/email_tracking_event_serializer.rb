# frozen_string_literal: true
class EmailTrackingEventSerializer < ActiveModel::Serializer
  attributes :created_at, :event
end
