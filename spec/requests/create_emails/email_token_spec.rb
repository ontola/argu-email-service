# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Email token', type: :request do
  let(:message) { '' }
  let(:email_opts) do
    {
      iri: 'http://example.com/tokenId',
      message: message,
      group_id: 1,
      actor_iri: 'https://argu.local/argu/u/1'
    }
  end

  it 'posts email' do
    group_mock(1)
    user_mock(1, root: 'argu', token: ENV['SERVICE_TOKEN'])

    as_service
    Sidekiq::Worker.drain_all
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post '/argu/email/spi/emails',
           params: {
             email: {
               template: 'email_token_created',
               recipient: {email: 'test@email.com'},
               options: email_opts
             }
           }, headers: service_headers
      expect(response.code).to eq('201')
    end
    assert(EmailMessage.last.sent_at)
    assert_equal EmailMessage.last.sent_to, 'test@email.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Invitation for Page name'
    assert_match(
      'You have been invited to join the group \'Group1\' of Page name',
      ActionMailer::Base.deliveries.first.body.encoded
    )
    assert_match 'tokenId', ActionMailer::Base.deliveries.first.body.encoded
  end

  context 'with message' do
    let(:message) { 'This is a message' }

    it 'posts email' do
      group_mock(1)
      user_mock(1, root: 'argu', token: ENV['SERVICE_TOKEN'])

      as_service
      Sidekiq::Worker.drain_all
      assert_difference('ActionMailer::Base.deliveries.size', 1) do
        post '/argu/email/spi/emails',
             params: {
               email: {
                 template: 'email_token_created',
                 recipient: {email: 'test@email.com'},
                 options: email_opts
               }
             }, headers: service_headers
        expect(response.code).to eq('201')
      end
      assert(EmailMessage.last.sent_at)
      assert_equal EmailMessage.last.sent_to, 'test@email.com'
      assert_equal ActionMailer::Base.deliveries.first.subject, 'Invitation for Page name'
      refute_match(
        'You have been invited to join the group \'groupName\' of Page name',
        ActionMailer::Base.deliveries.first.body.encoded
      )
      assert_match 'This is a message', ActionMailer::Base.deliveries.first.body.encoded
      assert_match 'tokenId', ActionMailer::Base.deliveries.first.body.encoded
      assert_match 'This is a message', ActionMailer::Base.deliveries.first.body.encoded
    end
  end
end
