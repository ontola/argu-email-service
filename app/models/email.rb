# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_tracking_events
  belongs_to :event
  validates :recipient, presence: true
  validate :valid_mailer

  def deliver_now
    touch # make sure the lock is still valid before sending the mail
    r = mailer.constantize.send(template, self).deliver_now
    update!(sent_at: DateTime.current, sent_to: r.to.first, mailgun_id: r.try(:message_id))
  end

  def options
    super&.with_indifferent_access || {}
  end

  def recipient
    @recipient ||= User.new(attributes['recipient']) if attributes['recipient'].present?
  end

  private

  def valid_mailer
    unless mailer.safe_constantize && mailer.include?('Mailer')
      errors.add(:mailer, :invalid)
      return
    end
    errors.add(:template, :invalid) unless mailer.constantize.respond_to?(template.to_sym)
  end
end
