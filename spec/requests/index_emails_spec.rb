# frozen_string_literal: true
require 'spec_helper'

describe 'Index emails' do
  it 'should get index emails' do
    2.times { create_email_event }
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all
    Email.last.email_tracking_events.create(event: 'delivered')

    get '/emails?resource=https://argu.local/u/user1&event=update'
    expect(response.code).to eq('200')
    expect_data_size(2)
    expect_included(EmailTrackingEvent.pluck(:id))
  end

  private

  def create_email_event
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
end
