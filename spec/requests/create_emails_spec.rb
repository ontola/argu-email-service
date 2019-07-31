# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create emails', type: :request do
  context 'when invalid' do
    it "don't post invalid template" do
      as_service
      post '/argu/spi/emails',
           params: {email: {template: 'invalid', recipient: {email: 'test@email.com'}}},
           headers: service_headers
      expect(response.code).to eq('404')
    end

    it "don't post empty recipient" do
      as_service
      post '/argu/spi/emails',
           params: {email: {template: 'password_changed', recipient: {}}},
           headers: service_headers
      expect(response.code).to eq('422')
    end
  end
end
