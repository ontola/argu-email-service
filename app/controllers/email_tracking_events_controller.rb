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
    process_mailjet_event if mailjet_event?
    head 200
  rescue ActiveRecord::RecordNotFound
    head 406
  end

  private

  def authorize_action
    skip_verify_policy_authorized(sure: true)
    true
  end

  def mailjet_event?
    @mailjet_event ||= params['CustomID'].present?
  end

  def process_mailjet_event
    EmailMessage
      .find(params['CustomID'])
      &.email_tracking_events
      &.create(event: MAILJET_EVENTS[params['event']] || params['event'], params: params.to_unsafe_h)
  end
end
