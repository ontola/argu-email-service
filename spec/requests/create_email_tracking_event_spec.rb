# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create email tracking event', type: :request do
  let!(:event) do
    create_event(
      'update',
      'https://argu.local/u/1',
      'users',
      changes: {
        encryptedPassword: '[FILTERED]',
        updatedAt: [1.day.ago, Time.current]
      }
    )
  end

  it 'posts event with send emails' do
    user_mock(1)
    user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 1) do
      post '/email_events', params: {
        CustomID: EmailMessage.last.id,
        recipient: EmailMessage.last.sent_to,
        event: 'clicked',
        payload: {error: 'value'},
        format: :json
      }
      expect(response.code).to eq('200')
      expect(EmailTrackingEvent.last.params['payload']['error']).to eq('value')
    end
  end

  it 'posts event for non-existing mail-id' do
    user_mock(1)
    user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email_events', params: {
        CustomID: 'not-existing',
        recipient: EmailMessage.last.sent_to,
        event: 'clicked',
        format: :json
      }
      expect(response.code).to eq('406')
    end
  end

  it 'posts event without mail-id' do
    user_mock(1)
    user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email_events', params: {
        recipient: EmailMessage.last.sent_to,
        event: 'clicked',
        format: :json
      }
      expect(response.code).to eq('200')
    end
  end
end
