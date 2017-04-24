# frozen_string_literal: true
require 'openssl'

class EmailEventsController < ApplicationController
  before_action :verify

  def create
    Email.find(params['argu-mail-id'])&.email_events&.create(event: params['event']) if params['argu-mail-id'].present?
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
