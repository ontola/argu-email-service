# frozen_string_literal: true
require 'rails_helper'

describe 'Show event' do
  it 'should get event with send emails' do
    2.times { create_event }
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all
    Email.last.email_events.create(event: 'delivered')

    get '/events?resource=http://argu.local/u/user1.json&event=update'
    expect(response.code).to eq('200')
    expect_included_size(3)
    expect_included_attributes_keys(['sent-to', 'sent-at', 'mailgun-id'])
    expect_included_attributes_keys(['sent-to', 'sent-at', 'mailgun-id'], 1)
    expect_included_attributes_keys(['created-at', 'event'], 2)
  end

  private

  def create_event
    create(:event,
           event: 'update',
           resource: 'http://argu.local/u/user1.json',
           resource_type: 'User',
           type: 'UserEvent',
           options: {
             encrypted_password: '[FILTERED]',
             updated_at: [1.day.ago, DateTime.current]
           })
  end
end
