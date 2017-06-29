# frozen_string_literal: true
require 'test_helper'

class TokenCreateTest < ActiveSupport::TestCase
  test 'should mail when email token created without message and profile_iri' do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    valid_user_mock(1)

    Event.create(
      event: 'create',
      resource_id: 'https://argu.dev/token/xxx',
      resource_type: 'tokens',
      type: 'TokenEvent',
      body: {
        affected_resources: nil,
        changes: nil,
        event: 'create',
        resource: {
          id: 148,
          type: 'tokens',
          attributes:
            {
              usages: 0,
              createdAt: DateTime.current,
              expiresAt: nil,
              retractedAt: nil,
              email: 'test@example.com',
              message: '',
              profileIRI: nil,
              sendMail: true,
              groupId: 1
            },
          links: {self: 'https://argu.dev/tokens/xxx'}
        },
        resource_id: 'https://argu.dev/token/xxx',
        resource_type: 'tokens'
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

  test 'should mail when email token created with message and profile_iri' do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    valid_user_mock(1)

    Event.create(
      event: 'create',
      resource_id: 'https://argu.dev/token/xxx',
      resource_type: 'tokens',
      type: 'TokenEvent',
      body: {
        affected_resources: nil,
        changes: nil,
        event: 'create',
        resource: {
          id: 148,
          type: 'tokens',
          attributes:
            {
              usages: 0,
              createdAt: DateTime.current,
              expiresAt: nil,
              retractedAt: nil,
              email: 'test@example.com',
              sendMail: true,
              message: 'Hello world!',
              profileIRI: argu_url('/u/user1'),
              groupId: 1
            },
          links: {self: 'https://argu.dev/tokens/xxx'}
        },
        resource_id: 'https://argu.dev/token/xxx',
        resource_type: 'tokens'
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

    Event.create(
      event: 'create',
      resource_id: 'https://argu.dev/token/xxx',
      resource_type: 'tokens',
      type: 'TokenEvent',
      body: {
        affected_resources: nil,
        changes: nil,
        event: 'create',
        resource: {
          id: 148,
          type: 'tokens',
          attributes:
            {
              usages: 0,
              createdAt: DateTime.current,
              expiresAt: nil,
              retractedAt: nil,
              sendMail: true,
              groupId: 1
            },
          links: {self: 'https://argu.dev/tokens/xxx'}
        },
        resource_id: 'https://argu.dev/token/xxx',
        resource_type: 'tokens'
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  test 'should not mail when email token created with send_mail = false' do
    group_mock(1)
    valid_user_mock(1)

    Event.create(
      event: 'create',
      resource_id: 'https://argu.dev/token/xxx',
      resource_type: 'tokens',
      type: 'TokenEvent',
      body: {
        affected_resources: nil,
        changes: nil,
        event: 'create',
        resource: {
          id: 148,
          type: 'tokens',
          attributes:
            {
              usages: 0,
              createdAt: DateTime.current,
              expiresAt: nil,
              retractedAt: nil,
              email: 'test@example.com',
              sendMail: false,
              groupId: 1
            },
          links: {self: 'https://argu.dev/tokens/xxx'}
        },
        resource_id: 'https://argu.dev/token/xxx',
        resource_type: 'tokens'
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  test 'should not mail when email token changed' do
    group_mock(1)
    valid_user_mock(1)

    Event.create(
      event: 'update',
      resource_id: 'https://argu.dev/token/xxx',
      resource_type: 'tokens',
      type: 'TokenEvent',
      body: {
        affected_resources: nil,
        changes: nil,
        event: 'create',
        resource: {
          id: 148,
          type: 'tokens',
          attributes:
            {
              usages: 0,
              createdAt: DateTime.current,
              expiresAt: nil,
              retractedAt: nil,
              email: 'test@example.com',
              sendMail: true,
              groupId: 1
            },
          links: {self: 'https://argu.dev/tokens/xxx'}
        },
        resource_id: 'https://argu.dev/token/xxx',
        resource_type: 'tokens'
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end
end
