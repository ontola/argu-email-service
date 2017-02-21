# frozen_string_literal: true
source 'https://rubygems.org'

gem 'puma', '~> 3.6.2'
gem 'rails', '~> 5.0.1'

gem 'active_model_serializers', '~> 0.10.4'
gem 'activeresource',
    git: 'https://github.com/rails/activeresource',
    branch: 'master'
gem 'bugsnag', '~> 4.2.1'
gem 'bunny', '~> 2.6.1'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'jwt'
gem 'mailgun_rails'
gem 'pragmatic_context'
gem 'roadie-rails', '~> 1.0'
gem 'service_base', git: 'git@bitbucket.org:arguweb/service_base.git', tag: 'v0.0.5'
gem 'sidekiq'
gem 'sidetiq'
gem 'slim'
gem 'tzinfo-data'

group :development, :production do
  gem 'pg', '~> 0.19.0'
end

group :development, :test do
  gem 'binding_of_caller'
  gem 'brakeman', '~> 3.4.1'
  gem 'bundler-audit', '~> 0.5.0'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.46.0'
end

group :development do
  gem 'better_errors'
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'web-console'
end

group :test do
  gem 'assert_difference'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'sqlite3', '~> 1.3.13'
  gem 'webmock'
end
