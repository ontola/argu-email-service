# frozen_string_literal: true

source 'https://rubygems.org'

gem 'puma'
gem 'rails', '~> 5.2.6'

gem 'active_model_serializers', '~> 0.10.7'
gem 'active_response', git: 'https://github.com/ontola/active_response', branch: :master
gem 'activeresource', git: 'https://github.com/ArthurWD/activeresource', branch: :master
gem 'acts_as_tenant', git: 'https://github.com/ArthurWD/acts_as_tenant', branch: :master
gem 'apartment'
gem 'bootsnap'
gem 'bugsnag', '~> 4.2.1'
gem 'bunny', '~> 2.6.1'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'fast_jsonapi', git: 'https://github.com/fast-jsonapi/fast_jsonapi', ref: '2de80d48896751d30fb410e042fd21a710100423'
gem 'health_check'
gem 'html_truncator'
gem 'json-ld'
gem 'jwt'
gem 'linked_rails', git: 'https://github.com/ontola/linked_rails', branch: :refactor
gem 'mailjet', git: 'https://github.com/mailjet/mailjet-gem', ref: '0edfa4'
gem 'nokogiri'
gem 'oauth2'
gem 'oj'
gem 'pragmatic_context'
gem 'pundit', '~> 1.0.0'
gem 'rdf'
gem 'rdf-n3'
gem 'rdf-rdfa'
gem 'rdf-rdfxml', git: 'https://github.com/ruby-rdf/rdf-rdfxml', ref: 'dd99a73'
gem 'rdf-serializers', git: 'https://github.com/ontola/rdf-serializers', branch: 'fast-jsonapi'
gem 'rdf-turtle'
gem 'redcarpet'
gem 'roadie-rails'
gem 'sidekiq'
gem 'sidetiq'
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
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
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
