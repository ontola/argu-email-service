# frozen_string_literal: true

source 'https://rubygems.org'

gem 'puma'
gem 'rails', '~> 6'

gem 'active_model_serializers', '~> 0.10.7'
gem 'activeresource', git: 'https://github.com/ArthurWD/activeresource', branch: :master
gem 'active_response', git: 'https://github.com/ontola/active_response', branch: :master
gem 'acts_as_tenant', git: 'https://github.com/ArthurWD/acts_as_tenant', branch: :master
gem 'bootsnap'
gem 'bugsnag'
gem 'bunny', '~> 2.6.1'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'fast_jsonapi', git: 'https://github.com/fast-jsonapi/fast_jsonapi', ref: '2de80d48896751d30fb410e042fd21a710100423'
gem 'health_check'
gem 'html_truncator'
gem 'json-ld'
gem 'jwt'
gem 'linked_rails', git: 'https://github.com/ontola/linked_rails', branch: :empathy
gem 'mailjet', git: 'https://github.com/mailjet/mailjet-gem', ref: '0edfa4'
gem 'nokogiri'
gem 'oauth2'
gem 'oj'
gem 'pragmatic_context'
gem 'pundit'
gem 'rdf'
gem 'rdf-n3'
gem 'rdf-rdfa'
gem 'rdf-rdfxml', git: 'https://github.com/ruby-rdf/rdf-rdfxml', ref: 'dd99a73'
gem 'rdf-turtle'
gem 'redcarpet'
gem 'roadie-rails'
gem 'ros-apartment',
    git: 'https://github.com/rails-on-services/apartment',
    require: 'apartment'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'slim'
gem 'tzinfo-data'
gem 'uri_template'

group :development, :production do
  gem 'pg'
end

group :development, :test do
  gem 'binding_of_caller'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.92.0'
  gem 'rubocop-rails', '~> 2.5.2'
  gem 'rubocop-rspec', '~> 1.39.0'
end

group :development do
  gem 'better_errors'
  gem 'listen'
  gem 'web-console'
end

group :test do
  gem 'assert_difference'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'sqlite3'
  gem 'webmock'
end
