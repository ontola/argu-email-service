# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirm votes', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'confirm_votes',
               recipient: {email: 'test@email.com'},
               options: {
                 token_url: 'http://example.com/confirmationToken',
                 motions: [
                   {display_name: 'Motion 1', url: '', option: 'Agree'},
                   {display_name: 'Motion 2', url: '', option: 'Against'}
                 ]
               }
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your votes'
    assert_match 'Motion 1</a>: Agree', ActionMailer::Base.deliveries.first.body.encoded
    assert_match 'Motion 2</a>: Against', ActionMailer::Base.deliveries.first.body.encoded
  end
end
