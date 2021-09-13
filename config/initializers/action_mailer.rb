# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging? || ENV['LOCAL_TEST_MODE'] == 'true'
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: ENV['MAIL_ADDRESS'].presence || '127.0.0.1',
    port: ENV['MAIL_PORT'].presence || 1025
  }

  ActionMailer::Base.perform_caching = false
elsif Rails.env.production?
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = ENV['DELIVERY_METHOD']&.to_sym || :mailjet_api
end
