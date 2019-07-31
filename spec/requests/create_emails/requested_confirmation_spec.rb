# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Requested confirmation', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/spi/emails',
           params: {
             email: {
               template: 'requested_confirmation',
               recipient: {email: 'test@email.com'},
               options: {email: 'secondary@email.com', confirmationToken: 'confirmationToken'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'secondary@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Confirm your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
