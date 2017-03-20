# frozen_string_literal: true
Rails.application.configure do
  if Rails.env.development? || Rails.env.staging?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: '127.0.0.1',
      port: ENV['MAIL_PORT'].presence || 1025
    }

    config.action_mailer.perform_caching = false
  elsif Rails.env.production?
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: Rails.application.secrets.mailgun_api_token,
      domain: Rails.application.secrets.mailgun_domain
    }
  end
end
