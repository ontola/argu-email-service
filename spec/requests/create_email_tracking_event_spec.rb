# frozen_string_literal: true

require 'spec_helper'

describe 'Create email tracking event', type: :request do
  let!(:event) do
    create_event(
      'update',
      'https://argu.local/u/user1',
      'users',
      changes: {
        encryptedPassword: '[FILTERED]',
        updatedAt: [1.day.ago, DateTime.current]
      }
    )
  end

  it 'posts event with send emails' do
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 1) do
      post '/email_events', params: {
        'argu-mail-id': Email.last.id,
        recipient: Email.last.sent_to,
        event: 'clicked',
        format: :json
      }
      expect(response.code).to eq('200')
    end
  end

  it 'posts event for non-existing mail-id' do
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email_events', params: {
        'argu-mail-id': 'not-existing',
        recipient: Email.last.sent_to,
        event: 'clicked',
        format: :json
      }
      expect(response.code).to eq('406')
    end
  end

  it 'posts event without mail-id' do
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all

    assert_difference('EmailTrackingEvent.count', 0) do
      post '/email_events', params: {
        recipient: Email.last.sent_to,
        event: 'clicked',
        format: :json
      }
      expect(response.code).to eq('200')
    end
  end
end
