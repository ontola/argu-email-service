# frozen_string_literal: true
require 'spec_helper'

describe 'Create email event' do
  let!(:event) do
    create(:event,
           event: 'update',
           resource_id: 'https://argu.local/u/user1',
           resource_type: 'users',
           type: 'UserEvent',
           body: {
             changes: [{
               id: 'https://argu.local/u/user1',
               type: 'users',
               attributes: {
                 encryptedPassword: '[FILTERED]',
                 updatedAt: [1.day.ago, DateTime.current]
               }
             }]
           })
  end

  it 'should get event with send emails' do
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all

    post '/email_events', params: {
      'argu-mail-id': Email.last.id,
      recipient: Email.last.sent_to,
      event: 'clicked'
    }
    expect(response.code).to eq('200')
  end
end
