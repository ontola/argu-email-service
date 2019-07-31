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
          email: 'test@email.com'
        },
        options: {
          actor: {
            iri: argu_url('/u/1'),
            display_name: 'Mail sender'
          },
          body: 'This is the body of the message',
          email: 'sender@email.com',
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
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/spi/emails', params: params, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Subject of message'
    assert_equal ActionMailer::Base.deliveries.first.header['from'].value, 'Mail sender <noreply@argu.co>'
    expect(ActionMailer::Base.deliveries.first.reply_to).to include('sender@email.com')
    assert_match 'This is the body of the message', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion title', ActionMailer::Base.deliveries.first.body.encoded
  end
end
