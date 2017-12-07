# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Direct message', type: :request do
  let(:params) do
    {
      email: {
        template: 'direct_message',
        recipient: {
          display_name: 'Motion poster',
          email: 'test@example.com'
        },
        options: {
          actor: {
            iri: argu_url('/u/user1'),
            display_name: 'Mail sender'
          },
          body: 'This is the body of the message',
          email: 'sender@example.com',
          resource: {
            display_name: 'Motion title',
            iri: argu_url('/m/1')
          },
          subject: 'Subject of message'
        }
      }
    }
  end

  it 'posts email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails', params: params
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Subject of message'
    assert_equal ActionMailer::Base.deliveries.first.header['from'].value, 'Mail sender <sender@example.com>'
    expect(ActionMailer::Base.deliveries.first.reply_to).to include('sender@example.com')
    assert_match 'This is the body of the message', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion title', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion poster', ActionMailer::Base.deliveries.first.body.encoded
  end
end
