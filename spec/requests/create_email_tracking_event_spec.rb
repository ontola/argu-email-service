# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create email tracking event', type: :request do
  let!(:email_message) { create(:email_message) }

  it 'posts event with send emails' do
    as_guest

    assert_difference('Apartment::Tenant.switch(\'argu\') { EmailTrackingEvent.count }', 1) do
      post '/email/_public/email_events', params: {
        CustomID: email_message.id,
        recipient: email_message.sent_to,
        event: 'clicked',
        payload: {error: 'value'},
        format: :json
      }, headers: service_headers
      expect(response.code).to eq('200')
      Apartment::Tenant.switch('argu') do
        expect(EmailTrackingEvent.last.params['payload']['error']).to eq('value')
      end
    end
  end

  it 'posts event for non-existing mail-id' do
    as_guest

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email/_public/email_events', params: {
        CustomID: 'not-existing',
        recipient: email_message.sent_to,
        event: 'clicked',
        format: :json
      }, headers: service_headers
      expect(response.code).to eq('406')
    end
  end

  it 'posts event without mail-id' do
    as_guest

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email/_public/email_events', params: {
        recipient: email_message.sent_to,
        event: 'clicked',
        format: :json
      }, headers: service_headers
      expect(response.code).to eq('200')
    end
  end
end
