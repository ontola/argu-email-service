# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Confirm votes', type: :request do
  it 'posts email' do
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
end
