# frozen_string_literal: true

require 'spec_helper'

describe 'Create emails', type: :request do
  context 'invalid' do
    it 'don\'t post invalid mailer' do
      post '/spi/emails',
           params: {email: {mailer: 'invalid', template: 'invalid', recipient: {email: 'test@example.com'}}}
      expect(response.code).to eq('422')
    end

    it 'don\'t post invalid template' do
      post '/spi/emails',
           params: {email: {mailer: 'UserMailer', template: 'invalid', recipient: {email: 'test@example.com'}}}
      expect(response.code).to eq('422')
    end

    it 'don\'t post empty recipient' do
      post '/spi/emails',
           params: {email: {mailer: 'UserMailer', template: 'password_changed', recipient: {}}}
      expect(response.code).to eq('422')
    end
  end

  it 'posts confirmation email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               mailer: 'EmailAddressMailer',
               template: 'confirmation',
               recipient: {email: 'test@example.com'},
               options: {confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'test@example.com'
    assert_equal Email.last.mailer, 'EmailAddressMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts confirmation email en' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               mailer: 'EmailAddressMailer',
               template: 'confirmation',
               recipient: {email: 'test@example.com', language: 'en'},
               options: {confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'test@example.com'
    assert_equal Email.last.mailer, 'EmailAddressMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts confirm_secondary email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               mailer: 'ConfirmationsMailer',
               template: 'confirm_secondary',
               recipient: {email: 'test@example.com'},
               options: {email: 'secondary@example.com', confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'secondary@example.com'
    assert_equal Email.last.mailer, 'ConfirmationsMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Voeg jouw e-mailadres toe'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts requested_confirmation email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               mailer: 'ConfirmationsMailer',
               template: 'requested_confirmation',
               recipient: {email: 'test@example.com'},
               options: {email: 'secondary@example.com', confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'secondary@example.com'
    assert_equal Email.last.mailer, 'ConfirmationsMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
