# frozen_string_literal: true

require_relative 'boot'

# require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

require_relative './initializers/version'
require_relative './initializers/build'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'linked_rails/middleware/linked_data_params'
require 'linked_rails/middleware/error_handling'
require_relative '../lib/acts_as_tenant/sidekiq_for_service'
require_relative '../lib/tenant_finder'
require_relative '../lib/tenant_middleware'
require_relative '../lib/ns'
require_relative '../lib/argu/redis'
require_relative '../lib/argu/i18n_error_handler'

module EmailService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.host_name = ENV['HOSTNAME']
    config.origin = "https://#{Rails.application.config.host_name}"
    config.service_name = 'emails'
    LinkedRails.host = config.host_name
    LinkedRails.scheme = :https

    ActiveModelSerializers.config.key_transform = :camel_lower

    config.templates = HashWithIndifferentAccess.new(
      YAML.safe_load(File.read(File.expand_path('templates.yml', __dir__)))
    )

    Rails.application.routes.default_scope = :email

    config.middleware.insert_after ActionDispatch::DebugExceptions, LinkedRails::Middleware::ErrorHandling
    config.middleware.insert_after ActionDispatch::DebugExceptions, TenantMiddleware
    config.middleware.use LinkedRails::Middleware::LinkedDataParams

    config.autoloader = :zeitwerk
    config.autoload_paths += %w[lib]
    config.autoload_paths += %W[#{config.root}/app/serializers/base]
    config.autoload_paths += %W[#{config.root}/app/models/events]
    config.autoload_paths += %W[#{config.root}/app/responders]

    config.active_job.queue_adapter = :sidekiq
    config.jwt_encryption_method = :hs512

    I18n.available_locales = %i[de nl en]
    config.i18n.available_locales = %i[de nl en]
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]

    require 'argu/message_delivery'

    Sidekiq.default_worker_options = {queue: 'email_service'}
    Rails.backtrace_cleaner.remove_silencers!
  end
end
