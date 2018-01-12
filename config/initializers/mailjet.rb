# frozen_string_literal: true

Mailjet.configure do |config|
  config.api_key = ENV['MAILJET_KEY']
  config.secret_key = ENV['MAILJET_SECRET']
  config.api_version = 'v3.1'
end
