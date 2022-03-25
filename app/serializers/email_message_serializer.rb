# frozen_string_literal: true

class EmailMessageSerializer < BaseSerializer
  attributes :id
  attributes :sent_to, predicate: NS.argu[:sentTo]
  attributes :sent_at, predicate: NS.argu[:sentAt]
  attributes :email_status, predicate: NS.argu[:emailStatus]

  has_many :email_tracking_events
end
