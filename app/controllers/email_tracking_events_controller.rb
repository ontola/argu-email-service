# frozen_string_literal: true

require 'openssl'

class EmailTrackingEventsController < ApplicationController
  before_action :verify

  def create
    if params['argu-mail-id'].present?
      EmailMessage.find(params['argu-mail-id'])&.email_tracking_events&.create(event: params['event'])
    end
    head 200
  rescue ActiveRecord::RecordNotFound
    head 406
  end

  private

  def verify
    return if Rails.env.test?
    digest = OpenSSL::Digest::SHA256.new
    data = [params['timestamp'], params['token']].join
    return if params['signature'] == OpenSSL::HMAC.hexdigest(digest, ENV['MAILGUN_API_TOKEN'], data)
    raise 'Verifying authenticity failed'
  end
end
