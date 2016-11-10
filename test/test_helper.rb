# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl_rails'
require 'minitest/spec'
require 'assert_difference'
require 'sidekiq/testing'
require 'webmock/minitest'
require 'argu/test_helpers'

module ActiveSupport
  class TestCase
    include FactoryGirl::Syntax::Methods
    include AssertDifference, TestMocks
    extend MiniTest::Spec::DSL
  end
end
