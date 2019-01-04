# frozen_string_literal: true

require 'openssl'

class EmailTrackingEventsController < ApplicationController
  MAILJET_EVENTS = {
    'open' => 'opened',
    'click' => 'clicked',
    'bounce' => 'bounced',
    'spam' => 'complained',
    'blocked' => 'blocked',
    'unsub' => 'unsubscribed',
    'sent' => 'delivered'
  }.freeze

  skip_before_action :check_if_registered
  skip_before_action :set_locale

  def create
    if mailgun_event?
      process_mailgun_event
    elsif mailjet_event?
      process_mailjet_event
    end
    head 200
  rescue ActiveRecord::RecordNotFound
    head 406
  end

  private

  def authorize_action
    skip_verify_policy_authorized(true)
    mailgun_event? ? verify_mailgun_event : true
  end

  def mailgun_event?
    @mailgun_event ||= params['argu-mail-id'].present?
  end

  def mailjet_event?
    @mailjet_event ||= params['CustomID'].present?
  end

  def process_mailgun_event
    verify_mailgun_event
    EmailMessage
      .find(params['argu-mail-id'])
      &.email_tracking_events
      &.create(event: params['event'], params: params.to_unsafe_h)
  end

  def process_mailjet_event
    EmailMessage
      .find(params['CustomID'])
      &.email_tracking_events
      &.create(event: MAILJET_EVENTS[params['event']] || params['event'], params: params.to_unsafe_h)
  end

  def verify_mailgun_event
    return if Rails.env.test?
    digest = OpenSSL::Digest::SHA256.new
    data = [params['timestamp'], params['token']].join
    return if params['signature'] == OpenSSL::HMAC.hexdigest(digest, ENV['MAILGUN_API_TOKEN'], data)
    raise 'Verifying authenticity failed'
  end
end
