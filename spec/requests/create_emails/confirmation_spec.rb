# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirmation', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'confirmation',
               recipient: {email: 'test@email.com'},
               options: {token_url: 'http://example.com/confirmationToken'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts email en' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'confirmation',
               recipient: {email: 'test@email.com', language: NS::ARGU['language#en']},
               options: {token_url: 'http://example.com/confirmationToken'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
