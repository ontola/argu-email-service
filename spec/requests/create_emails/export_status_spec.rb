# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Export status', type: :request do
  it 'posts email success' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'export_done',
               recipient: {email: 'test@email.com'},
               options: {download_url: 'http://example.com/downloadZip'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Export ready'
    assert_match 'http://example.com/downloadZip', ActionMailer::Base.deliveries.first.body.encoded
  end

  it 'posts email failure' do
    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'export_failed',
               recipient: {email: 'test@email.com'}
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Export failed'
  end
end
