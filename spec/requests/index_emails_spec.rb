# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Index emails', type: :request do
  it 'gets index emails' do
    2.times { create_email_event }
    as_user
    user_mock(1, url: expand_service_url(:argu, '/u/1'))
    user_mock(2, url: expand_service_url(:argu, '/u/2'))
    Sidekiq::Worker.drain_all
    EmailMessage.last.email_tracking_events.create(event: 'delivered')

    as_service
    get '/argu/email/emails?resource=https://argu.local/u/1&event=update', headers: service_headers
    expect(response.code).to eq('200')
    expect_data_size(2)
    expect_included(EmailTrackingEvent.pluck(:id))
  end

  private

  def create_email_event
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
end
