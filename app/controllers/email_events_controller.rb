# frozen_string_literal: true
require 'openssl'

class EmailEventsController < ApplicationController
  before_action :verify

  def create
    email = Email.find_by(id: params['argu-mail-id'])
    if email.present?
      email.email_events.create(event: params['event'])
      head 200
    else
      head 406
    end
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
