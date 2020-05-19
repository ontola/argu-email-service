# frozen_string_literal: true

class EventSerializer < BaseSerializer
  attributes :id
  has_many :email_messages
end
