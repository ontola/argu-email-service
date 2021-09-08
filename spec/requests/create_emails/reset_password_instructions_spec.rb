# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Reset password instructions', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'reset_password_instructions',
               recipient: {email: 'test@email.com'},
               options: {token_url: 'http://example.com/passwordToken'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Password reset instructions'
    assert_match 'passwordToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
