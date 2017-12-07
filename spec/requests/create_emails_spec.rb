# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create emails', type: :request do
  context 'invalid' do
    it "don't post invalid template" do
      post '/spi/emails',
           params: {email: {template: 'invalid', recipient: {email: 'test@example.com'}}}
      expect(response.code).to eq('404')
    end

    it "don't post empty recipient" do
      post '/spi/emails',
           params: {email: {template: 'password_changed', recipient: {}}}
      expect(response.code).to eq('422')
    end
  end
end
