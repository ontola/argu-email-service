# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirm secondary', type: :request do
  it 'posts email' do
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
end
