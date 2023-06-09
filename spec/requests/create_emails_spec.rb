# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create emails', type: :request do
  context 'when invalid' do
    it "don't post email as guest" do
      as_guest
      post '/argu/email/spi/emails',
           params: {email: {template: 'password_changed', recipient: {email: 'test@email.com'}}},
           headers: service_headers
      expect(response.code).to eq('401')
    end

    it "don't post email without SPI" do
      as_service
      assert_raises(ActionController::RoutingError) do
        post '/argu/email/emails',
             params: {email: {template: 'password_changed', recipient: {email: 'test@email.com'}}},
             headers: service_headers
      end
    end

    it "don't post email on email_messages route" do
      as_service
      assert_raises(ActionController::RoutingError) do
        post '/argu/email/email_messages',
             params: {email: {template: 'password_changed', recipient: {email: 'test@email.com'}}},
             headers: service_headers
      end
    end

    it "don't post invalid template" do
      as_service
      post '/argu/email/spi/emails',
           params: {email: {template: 'invalid', recipient: {email: 'test@email.com'}}},
           headers: service_headers
      expect(response.code).to eq('404')
    end

    it "don't post empty recipient" do
      as_service
      post '/argu/email/spi/emails',
           params: {email: {template: 'password_changed', recipient: {}}},
           headers: service_headers
      expect(response.code).to eq('422')
    end

    it 'stores source_identifier' do
      as_service
      identifier = SecureRandom.uuid
      post '/argu/email/spi/emails',
           params: {
             email: {
               source_identifier: identifier,
               template: 'password_changed',
               recipient: {email: 'test@email.com'}
             }
           },
           headers: service_headers
      expect(response.code).to eq('201')
      assert_equal EmailMessage.last.source_identifier, identifier
    end
  end
end
