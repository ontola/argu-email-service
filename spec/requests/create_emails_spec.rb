# frozen_string_literal: true

require 'spec_helper'

describe 'Create emails', type: :request do
  context 'invalid' do
    it "don't post invalid template" do
      post '/spi/emails',
           params: {email: {template: 'invalid', recipient: {email: 'test@example.com'}}}
      expect(response.code).to eq('404')
    end

    it "don't post empty recipient" do
      post '/spi/emails',
           params: {email: {template: 'password_changed', recipient: {}}}
      expect(response.code).to eq('422')
    end
  end

  it 'posts confirmation email' do
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

  it 'posts confirmation email en' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirmation',
               recipient: {email: 'test@example.com', language: 'en'},
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

  it 'posts confirm_secondary email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirm_secondary',
               recipient: {email: 'test@example.com'},
               options: {email: 'secondary@example.com', confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'secondary@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Voeg jouw e-mailadres toe'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts requested_confirmation email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'requested_confirmation',
               recipient: {email: 'test@example.com'},
               options: {email: 'secondary@example.com', confirmationToken: 'confirmationToken'}
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'secondary@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts confirm_votes email' do
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirm_votes',
               recipient: {email: 'test@example.com'},
               options: {
                 confirmationToken: 'confirmationToken', motions: [
                   {display_name: 'Motion 1', url: '', option: 'pro'},
                   {display_name: 'Motion 2', url: '', option: 'con'}
                 ]
               }
             }
           }
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw stemmen'
    assert_match 'V=C3=B3=C3=B3r', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion 1', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Tegen', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts set_password email' do
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
