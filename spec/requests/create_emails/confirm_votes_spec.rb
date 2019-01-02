# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirm votes', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/spi/emails',
           params: {
             email: {
               template: 'confirm_votes',
               recipient: {email: 'test@email.com'},
               options: {
                 confirmationToken: 'confirmationToken', motions: [
                   {display_name: 'Motion 1', url: '', option: 'pro'},
                   {display_name: 'Motion 2', url: '', option: 'con'}
                 ]
               }
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your votes'
    assert_match 'In favour of', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion 1', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Against', ActionMailer::Base.deliveries.first.body.encoded
  end
end
