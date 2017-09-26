# frozen_string_literal: true

require 'test_helper'

class TokenCreateTest < ActiveSupport::TestCase
  test 'should mail when email token created without message and actor_iri' do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    valid_user_mock(1)

    create_token_event(
      attributes: {
        email: 'test@example.com',
        message: '',
        actorIRI: nil,
        sendMail: true
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.header['From'].value, 'Argu <noreply@argu.co>'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Uitnodiging voor Argu op Argu'
    assert_match 'Je bent uitgenodigd om lid te worden van de groep \'Group1\' van Argu',
                 ActionMailer::Base.deliveries.first.body.to_s
  end

  test 'should mail when email token created with message and actor_iri' do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    valid_user_mock(1)

    create_token_event(
      attributes: {
        email: 'test@example.com',
        message: 'Hello world!',
        actorIRI: argu_url('/u/user1'),
        sendMail: true
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'test@example.com'
    assert_equal ActionMailer::Base.deliveries.first.header['From'].value, 'User1 <noreply@argu.co>'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Uitnodiging voor Argu op Argu'
    assert_match 'Hello world!', ActionMailer::Base.deliveries.first.body.encoded
  end

  test 'should not mail when bearer token created' do
    group_mock(1)
    valid_user_mock(1)

    create_token_event(
      attributes: {
        sendMail: true
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  test 'should not mail when email token created with send_mail = false' do
    group_mock(1)
    valid_user_mock(1)

    create_token_event(
      attributes: {
        email: 'test@example.com',
        sendMail: false
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  private

  def create_token_event(attrs)
    create_event(
      'create',
      'https://argu.dev/token/xxx',
      'tokens',
      attributes: default_token_attrs.merge(attrs[:attributes]),
      changes: attrs[:changes]
    )
  end

  def default_token_attrs
    {
      usages: 0,
      createdAt: DateTime.current,
      expiresAt: nil,
      retractedAt: nil,
      groupId: 1
    }
  end
end
