# frozen_string_literal: true

class EmailSerializer < ActiveModel::Serializer
  attributes :id, :sent_to, :sent_at
  has_many :email_tracking_events
end
