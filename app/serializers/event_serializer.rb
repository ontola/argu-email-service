# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id
  has_many :emails
end
