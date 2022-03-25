# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Show emails', type: :request do
  let(:email_message) { create(:email_message, source_identifier: SecureRandom.uuid) }

  it 'shows emails with status' do
    as_service

    get "/argu/email/email_messages/#{email_message.source_identifier}", headers: service_headers(accept: :n3)

    expect(response.code).to eq('200')
  end
end
