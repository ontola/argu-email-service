# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Set password', type: :request do
  it 'posts email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'set_password',
               recipient: {email: 'test@example.com'},
               options: {passwordToken: 'passwordToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Stel een wachtwoord in'
    assert_match 'passwordToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
