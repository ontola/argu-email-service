# frozen_string_literal: true
class Email < ApplicationRecord
  has_many :email_tracking_events
  belongs_to :event

  def deliver_now
    r = event.mailer.send(template, self).deliver_now
    update(sent_at: DateTime.current, sent_to: r.to.first, mailgun_id: r.try(:message_id))
  end

  def recipient
    @recipient ||= User.new(attributes['recipient'])
  end
end
