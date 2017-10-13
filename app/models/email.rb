# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_tracking_events
  belongs_to :event
  belongs_to :template
  validates :recipient, presence: true

  def deliver_now
    touch # make sure the lock is still valid before sending the mail
    r = ApplicationMailer.template_mail(self).deliver_now
    update!(sent_at: DateTime.current, sent_to: r.to.first, mailgun_id: r.try(:message_id))
  end

  def options
    super&.with_indifferent_access || {}
  end

  def recipient
    @recipient ||= User.new(attributes['recipient']) if attributes['recipient'].present?
  end
end
