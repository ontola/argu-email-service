# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirmation', type: :request do
  it 'posts email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirmation',
               recipient: {email: 'test@example.com'},
               options: {confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts email en' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirmation',
               recipient: {email: 'test@example.com', language: NS::ARGU['locale/en']},
               options: {confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
