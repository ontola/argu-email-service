# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirm secondary', type: :request do
  it 'posts email' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/spi/emails',
           params: {
             email: {
               template: 'confirm_secondary',
               recipient: {email: 'test@email.com'},
               options: {email: 'secondary@email.com', confirmationToken: 'confirmationToken'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'secondary@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Add your e-mail address'
    assert_match 'confirmationToken', ActionMailer::Base.deliveries.first.body.encoded
  end
end
