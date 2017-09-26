# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: ENV['MAIL_ADDRESS'].presence || '127.0.0.1',
    port: ENV['MAIL_PORT'].presence || 1025
  }

  ActionMailer::Base.perform_caching = false
elsif Rails.env.production?
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :mailgun
  ActionMailer::Base.mailgun_settings = {
    api_key: Rails.application.secrets.mailgun_api_token,
    domain: Rails.application.secrets.mailgun_domain
  }
end
